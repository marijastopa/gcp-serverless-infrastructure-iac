import functions_framework
import os
import logging
from typing import Dict, List, Tuple, Any
from google.cloud import secretmanager
from google.cloud import storage
from google.api_core import exceptions
import json

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@functions_framework.http
def main(request) -> Tuple[str, int, Dict[str, str]]:
    """
    Cloud Function entry point.
    
    Verifies access to Secret Manager and lists files in Cloud Storage.
    Secret value is logged (not returned in response) for security.
    """
    try:
        project_id = get_project_id()
        secret_id = os.environ.get('SECRET_ID')
        bucket_name = os.environ.get('BUCKET_NAME')
        
        if not secret_id or not bucket_name:
            logger.error('Missing required environment variables')
            return format_response({
                'error': 'Missing required environment variables',
                'required': ['SECRET_ID', 'BUCKET_NAME']
            }, 500)
        
        # Verify secret access - value logged, not returned
        secret_verified = verify_secret_access(project_id, secret_id)
        
        # List files in bucket
        files = list_bucket_files(bucket_name)
        
        response = {
            'status': 'success',
            'secret_access_verified': secret_verified,
            'secret_id': secret_id,
            'bucket': bucket_name,
            'files_count': len(files),
            'files': files
        }
        
        logger.info(f'Request processed: {len(files)} files found')
        return format_response(response, 200)
        
    except exceptions.PermissionDenied as e:
        logger.error(f'Permission denied: {str(e)}')
        return format_response({
            'status': 'error',
            'message': 'Permission denied accessing resources'
        }, 403)
        
    except exceptions.NotFound as e:
        logger.error(f'Resource not found: {str(e)}')
        return format_response({
            'status': 'error',
            'message': 'Requested resource not found'
        }, 404)
        
    except Exception as e:
        logger.exception('Unexpected error processing request')
        return format_response({
            'status': 'error',
            'message': 'Internal server error'
        }, 500)


def verify_secret_access(project_id: str, secret_id: str) -> bool:
    client = secretmanager.SecretManagerServiceClient()
    name = f"projects/{project_id}/secrets/{secret_id}/versions/latest"
    
    response = client.access_secret_version(request={"name": name})
    secret_value = response.payload.data.decode('UTF-8')
    
    if not secret_value:
        raise ValueError(f'Secret {secret_id} is empty')
    
    environment = os.environ.get('ENVIRONMENT', 'prod')
    
    if environment == 'dev':
        # Full secret logging for connectivity verification in dev only
        logger.info(f'Secret {secret_id} retrieved successfully')
        logger.info(f'Secret value: {secret_value}')
    else:
        # Production: confirm access only, never log value
        logger.info(f'Secret {secret_id} retrieved successfully')
    
    return True


def list_bucket_files(bucket_name: str) -> List[Dict[str, Any]]:
    """
    List all files in Cloud Storage bucket.
    
    Args:
        bucket_name: Name of the storage bucket
        
    Returns:
        List of dictionaries with file metadata
    """
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blobs = bucket.list_blobs()
    
    files = []
    for blob in blobs:
        files.append({
            'name': blob.name,
            'size': blob.size,
            'content_type': blob.content_type,
            'updated': blob.updated.isoformat() if blob.updated else None
        })
    
    logger.info(f'Listed {len(files)} files from bucket: {bucket_name}')
    return files


def get_project_id() -> str:
    """
    Get project ID from environment variable.
    Set by Terraform via environment_variables config.
    """
    project_id = os.environ.get('GCP_PROJECT_ID')
    if not project_id:
        logger.error('GCP_PROJECT_ID environment variable not set')
        raise ValueError('GCP_PROJECT_ID environment variable not set')
    return project_id


def format_response(
    data: Dict[str, Any],
    status_code: int
) -> Tuple[str, int, Dict[str, str]]:
    """Format HTTP response with JSON body."""
    return (
        json.dumps(data, indent=2),
        status_code,
        {'Content-Type': 'application/json'}
    )