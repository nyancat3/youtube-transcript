from get_latest_video import get_latest_video
from get_transcript import get_transcript
import requests

def lambda_handler(event, context):
    print('ip: ' + requests.get('http://checkip.amazonaws.com').text.rstrip())

    video_url = get_latest_video()
    print(video_url)
    transcript = get_transcript(video_url)
    print(transcript)

    return {
        'statusCode': 200,
        'body': transcript
    }

if __name__ == "__main__":
    lambda_handler(None, None)
