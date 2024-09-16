import os
from dotenv import load_dotenv
from googleapiclient.discovery import build

def get_latest_video():
    load_dotenv()
    youtube = build('youtube', 'v3', developerKey=os.getenv("YOUTUBE_DATA_API_V3_KEY"))

    # Request the latest video from the uploads playlist
    playlist_items = youtube.playlistItems().list(
        part='snippet',
        playlistId=os.getenv('YOUTUBE_PLAYLIST_ID'),
        maxResults=1
    ).execute()

    # Extract video details
    latest_video = playlist_items['items'][0]['snippet']
    video_id = latest_video['resourceId']['videoId']
    # video_title = latest_video['title']
    # video_description = latest_video['description']

    return f"https://www.youtube.com/watch?v={video_id}"
