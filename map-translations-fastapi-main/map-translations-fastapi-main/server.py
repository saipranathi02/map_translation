# import uvicorn
# import io
# from fastapi import FastAPI
# # from pollutants import Pollutants

# import numpy as np
# # import pickle
# import pandas as pd
# from keras.models import load_model
# from tensorflow.keras.preprocessing.image import img_to_array
# from tensorflow.keras.preprocessing.image import load_img
# from tensorflow.keras.preprocessing.image import save_img
# import tensorflow as tf
# from numpy import expand_dims
# import cv2
# import base64
# from PIL import Image
# from type import GAN


# app = FastAPI()


# def load_image(filename, size=(256,256)):
#     pixels = load_img(filename, target_size=size)
#     pixels = img_to_array(pixels)
#     pixels = (pixels - 127.5) / 127.5
#     pixels = expand_dims(pixels, 0)
#     return pixels

# @app.get('/')
# def home():
#     return 'hello'

# @app.post('/generate')
# def generate(data : GAN):
#     # print(data)
#     # # image = flask.request.files['image'].read()
#     data=data.dict()
#     if(data['type']==0):
#         model = load_model('C:/Users/DELL/Downloads/model_109600.h5')
#         print('loaded model')
#     else:
#         model = load_model('C:/Users/DELL/Downloads/map2sat.h5')
#         print('loaded model')
#     # print(data)
#     image = data['image']
#     image = io.BytesIO(base64.b64decode(image))
#     image = load_image(image)
#     preds=model.predict(image)
#     output = tf.reshape(preds,[256,256,3])
#     output = (output+1)/2.0
#     print(output)
#     outputimg = 'xyz.png'
#     save_img(outputimg,img_to_array(output))
#     # import base64
#     with open(outputimg, "rb") as img_file:
#         my_string = base64.b64encode(img_file.read())
#     print(my_string)
#     response ={
#         "image" : my_string
#     }
#     return response


# if __name__ == '__main__':
#     uvicorn.run(app, host='127.0.0.1', port=5000)


# '''
import uvicorn
from fastapi import FastAPI
import numpy as np
import pandas as pd
from keras.models import load_model
from tensorflow.keras.preprocessing.image import img_to_array
from tensorflow.keras.preprocessing.image import load_img
from tensorflow.keras.preprocessing.image import save_img
import tensorflow as tf
from numpy import expand_dims, uint8
import cv2
import base64
from PIL import Image
from type import GAN
import os
from itertools import product
from PIL import ImageFile
ImageFile.LOAD_TRUNCATED_IMAGES = True

app = FastAPI()

def load_image(filename, size=(256,256)):
    pixels = load_img(filename, target_size=size)
    pixels = img_to_array(pixels)
    pixels = (pixels - 127.5) / 127.5
    pixels = expand_dims(pixels, 0)
    return pixels
def load_img2(filename):
    pixels = load_img(filename)
    pixels = img_to_array(pixels)
    pixels = (pixels - 127.5) / 127.5
    pixels = expand_dims(pixels, 0)
    
@app.get('/')
def home():
    return 'hello'


m1= load_model('C:/Users/DELL/Downloads/model_109600.h5')
m2 = load_model('C:/Users/DELL/Downloads/map2sat.h5')
@app.post('/predict')
def predict(data:GAN):
    data=data.dict()
    if(data['type']==0):
        model=m1
        print('loaded model')
    else:
        model=m2
        print('loaded model')
    image = data['image']
    # print(type(image))
    image = base64.b64decode(image)
    with open("imageToSave.jpg", "wb") as fh:
        fh.write(image)
    # print("hi")
    def tile(d):
        # name, ext = os.path.splitext(filename)
        img = Image.open('imageToSave.jpg')
        w, h = img.size
        
        # grid = product(range(0, h-h%d, d), range(0, w-w%d, d))
        l=[]
        for i in range(0, h-h%d, d):
            r=[]
            for j in range(0, w-w%d, d):
                print(i,j)
                box = (j, i, j+d, i+d)
                out = 'xyz.jpg'
                img.crop(box).save(out)
                img1 = load_image('xyz.jpg')
                gen_image = model.predict(img1)
                gen_image = (gen_image + 1) / 2.0
                output=gen_image[0]
                # img = img_to_array(output)
                # my_string = base64.b64encode(img)
                # img = Image.fromarray((gen_image[0]*255).astype(uint8))
                save_img('xyz.jpg',img_to_array(output))
                r.append(cv2.imread('xyz.jpg'))
            l.append(cv2.hconcat(r))
        print(len(l))
        result = cv2.vconcat(l)
        cv2.imwrite('imageToSave.jpg', result)
    tile(256)
    with open("imageToSave.jpg", "rb") as img_file:
        my_string = base64.b64encode(img_file.read())
    # print(image)
    response ={
        "image" : my_string
    }
    return response

if __name__ == '__main__':
    uvicorn.run(app, host='127.0.0.1', port=5000)
# '''