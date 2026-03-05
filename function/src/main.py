import functions_framework

@functions_framework.http
def main(request):
    """HTTP Cloud Function."""
    return 'Hello from Cloud Functions!', 200