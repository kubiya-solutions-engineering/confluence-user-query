FROM python:3.9-slim

WORKDIR /app

# Install dependencies
RUN pip install requests

# Copy the multi-search script
COPY confluence_multi_search.py /app/
RUN chmod +x /app/confluence_multi_search.py

# Set the entrypoint
ENTRYPOINT ["/app/confluence_multi_search.py"] 