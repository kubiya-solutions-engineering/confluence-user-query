#!/usr/bin/env python3
import os
import sys
import json
import requests
from base64 import b64encode

def search_across_spaces(query, space_keys, limit_per_space=5):
    """Search for content across multiple Confluence spaces."""
    
    # Get credentials from environment
    confluence_url = os.environ.get('CONFLUENCE_URL')
    username = os.environ.get('CONFLUENCE_USERNAME')
    api_token = os.environ.get('CONFLUENCE_API_TOKEN')
    
    if not all([confluence_url, username, api_token]):
        print("Error: Missing required environment variables")
        sys.exit(1)
    
    # Create auth header
    auth_string = f"{username}:{api_token}"
    encoded_auth = b64encode(auth_string.encode('utf-8')).decode('utf-8')
    headers = {
        "Authorization": f"Basic {encoded_auth}",
        "Content-Type": "application/json"
    }
    
    all_results = []
    
    # Search in each space
    for space_key in space_keys:
        # URL encode the query for CQL
        encoded_query = requests.utils.quote(f'text ~ "{query}" AND space = {space_key}')
        search_url = f"{confluence_url}/rest/api/content/search?cql={encoded_query}&limit={limit_per_space}"
        
        try:
            response = requests.get(search_url, headers=headers)
            response.raise_for_status()
            
            space_results = response.json()
            
            # Add space key to each result for reference
            for result in space_results.get('results', []):
                result['_space_key'] = space_key
                all_results.append(result)
                
            print(f"Found {len(space_results.get('results', []))} results in space {space_key}")
            
        except Exception as e:
            print(f"Error searching in space {space_key}: {str(e)}")
    
    # Sort results by relevance (if available) or title
    all_results.sort(key=lambda x: x.get('title', ''))
    
    # Format the results
    formatted_results = []
    for result in all_results:
        formatted_results.append({
            "id": result.get('id'),
            "title": result.get('title'),
            "type": result.get('type'),
            "space": result.get('_space_key'),
            "url": f"{confluence_url}/display/{result.get('_space_key')}/{result.get('id')}"
        })
    
    return formatted_results

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python confluence_multi_search.py 'search query' 'SPACE1,SPACE2,SPACE3'")
        sys.exit(1)
    
    query = sys.argv[1]
    space_keys = sys.argv[2].split(',')
    limit_per_space = int(sys.argv[3]) if len(sys.argv) > 3 else 5
    
    results = search_across_spaces(query, space_keys, limit_per_space)
    print(json.dumps(results, indent=2)) 