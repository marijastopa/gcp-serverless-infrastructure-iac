import pytest
from unittest.mock import Mock, patch, MagicMock
import json
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from main import main, verify_secret_access, list_bucket_files, get_project_id


def test_verify_secret_access_success():
    """Test successful secret retrieval"""
    with patch('main.secretmanager.SecretManagerServiceClient') as mock_client:
        mock_response = Mock()
        mock_response.payload.data = b'test-secret-value'
        mock_client.return_value.access_secret_version.return_value = mock_response
        
        result = verify_secret_access('test-project', 'test-secret')
        assert result is True


def test_verify_secret_access_empty_secret():
    """Test that empty secret raises error"""
    with patch('main.secretmanager.SecretManagerServiceClient') as mock_client:
        mock_response = Mock()
        mock_response.payload.data = b''
        mock_client.return_value.access_secret_version.return_value = mock_response
        
        with pytest.raises(ValueError, match='is empty'):
            verify_secret_access('test-project', 'test-secret')


def test_list_bucket_files():
    """Test listing files from Cloud Storage"""
    with patch('main.storage.Client') as mock_client:
        mock_blob = Mock()
        mock_blob.name = 'test-file.txt'
        mock_blob.size = 1024
        mock_blob.content_type = 'text/plain'
        mock_blob.updated = None
        
        mock_client.return_value.bucket.return_value.list_blobs.return_value = [mock_blob]
        
        result = list_bucket_files('test-bucket')
        assert len(result) == 1
        assert result[0]['name'] == 'test-file.txt'
        assert result[0]['content_type'] == 'text/plain'


def test_list_bucket_files_empty():
    """Test listing files from empty bucket"""
    with patch('main.storage.Client') as mock_client:
        mock_client.return_value.bucket.return_value.list_blobs.return_value = []
        
        result = list_bucket_files('test-bucket')
        assert result == []


def test_main_success():
    """Test successful request - verify secret NOT in response"""
    mock_request = Mock()
    
    with patch.dict(os.environ, {
        'GCP_PROJECT_ID': 'test-project',
        'SECRET_ID': 'test-secret',
        'BUCKET_NAME': 'test-bucket'
    }):
        with patch('main.verify_secret_access', return_value=True):
            with patch('main.list_bucket_files', return_value=[]):
                response, status_code, headers = main(mock_request)
                
                assert status_code == 200
                data = json.loads(response)
                assert data['status'] == 'success'
                assert data['secret_access_verified'] is True
                assert 'secret_value' not in data  # Security check!


def test_main_missing_env_vars():
    """Test missing environment variables"""
    mock_request = Mock()
    
    with patch.dict(os.environ, {}, clear=True):
        response, status_code, headers = main(mock_request)
        
        assert status_code == 500
        data = json.loads(response)
        assert 'error' in data


def test_get_project_id_missing():
    """Test get_project_id raises when env var not set"""
    with patch.dict(os.environ, {}, clear=True):
        with pytest.raises(ValueError, match='GCP_PROJECT_ID'):
            get_project_id()

def test_verify_secret_prod_no_sensitive_logging():
    """
    Verify that in production environment
    full secret value is not logged
    """
    with patch('main.secretmanager.SecretManagerServiceClient') as mock_client:
        mock_response = Mock()
        mock_response.payload.data = b'super-secret-value'
        mock_client.return_value.access_secret_version.return_value = mock_response
        
        with patch.dict(os.environ, {'ENVIRONMENT': 'prod'}):
            with patch('main.logger') as mock_logger:
                verify_secret_access('test-project', 'test-secret')
                
                # Check that full secret value was never logged
                logged_messages = [
                    str(call) for call in mock_logger.info.call_args_list
                ]
                for message in logged_messages:
                    assert 'super-secret-value' not in message


def test_verify_secret_dev_logs_value():
    """
    Verify that in dev environment secret value is logged
    for connectivity verification
    """
    with patch('main.secretmanager.SecretManagerServiceClient') as mock_client:
        mock_response = Mock()
        mock_response.payload.data = b'dev-secret-value'
        mock_client.return_value.access_secret_version.return_value = mock_response
        
        with patch.dict(os.environ, {'ENVIRONMENT': 'dev'}):
            with patch('main.logger') as mock_logger:
                verify_secret_access('test-project', 'test-secret')
                
                # Check that secret value was logged in dev
                logged_messages = [
                    str(call) for call in mock_logger.info.call_args_list
                ]
                assert any('dev-secret-value' in msg for msg in logged_messages)