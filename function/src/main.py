import functions_framework

@functions_framework.http
def main(request):
    """HTTP Cloud Function - Simple test."""
    return 'Hello from Cloud Functions!', 200
