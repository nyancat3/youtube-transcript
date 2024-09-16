from get_latest_video import get_latest_video
from get_transcript import get_transcript

def lambda_handler(event, context):
    video_url = get_latest_video()
    transcript = get_transcript(video_url)
    print(transcript)

    return {
        'statusCode': 200,
        'body': transcript
    }

if __name__ == "__main__":
    lambda_handler(None, None)
