from datetime import datetime
import boto3
from io import BytesIO
from PIL import Image, ImageOps
import os
import uuid
import json

s3 = boto3.client('s3')
dynamodb = boto3.resource(
    'dynamodb',region_name=str(os.environ['REGION_NAME']))
size = int(os.environ['THUMBNAIL_SIZE'])
dbtable = str(os.environ['DYNAMODB_TABLE'])

def s3_thumbnail_generator(event, context):
    print("EVENT:::",event)
    #AWS Lambda가 제공하는 데이터 속에서 새 이미지가 업로드된 S3 버킷의 이름을 찾아 추출하는 역할
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    img_size = event['Records'][0]['s3']['object']['size']

    if (not key.endswith("_thumbnail.png")):

        image = get_s3_image(bucket,key)


def get_s3_image(bucket, key):
   response = s3.get_object(Bucket=bucket, Key=key)
   imagecontent = response['Body'].read()

   file = BytesIO(imagecontent)
   img = Image.open(file)

   return img

def image_to_thumbnail(image):
    return ImageOps.fit(image, (size,size),Image.ANTIALIAS)
def new_filename(key):
    key_split = key.rsplit('.',1)
    return key_split[0]+"_thumbnail.png"
