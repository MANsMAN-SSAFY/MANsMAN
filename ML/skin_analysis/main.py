from fastapi import FastAPI
from transformers import pipeline
from pydantic import BaseModel
from database import engineconn
from model import Product
import keras
import math
import numpy as np
import tensorflow as tf
from tensorflow.keras.utils import load_img, img_to_array
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.preprocessing import LabelEncoder, MinMaxScaler
from matrix_factorization import KernelMF, train_update_test_split
from sklearn.metrics import mean_squared_error
import pickle
import random
import datetime

app = FastAPI()

face_shape_classification_pipeline = pipeline("image-classification", model="metadome/face_shape_classification")
skin_types_image_detection = pipeline("image-classification", model="dima806/skin_types_image_detection")
facial_age_image_detection = pipeline("image-classification", model="dima806/facial_age_image_detection")

# # # # acne-blackhead-wrinkle-saved-model 가져오기
# saved_model = keras.layers.TFSMLayer("acne-blackhead-wrinkle-saved-model", call_endpoint="serving_default")

face_characteristics_classifcation = pipeline("image-classification", model="varun1505/face-characteristics")

@app.get("/fastapi/test")
def getFaceCharacteristic():
     return face_characteristics_classifcation("https://health.chosun.com/site/data/img_dir/2019/07/31/2019073101071_0.jpg")

# # request body
class ImgUrl(BaseModel):
      imgUrl: str

#response body
# 얼굴형
class FaceShape(BaseModel):
      faceShape: str

# 피부 타입: 지성, 건성, 정상의 정도
class SkinType(BaseModel):
    oily: int
    dry: int
    normal: int

# 얼굴 사진을 바탕으로 나이 추정 
class Age(BaseModel):
      age: int

# 피부 분석 결과: 여드름, 주름, 블랙헤드의 정도
class SkinAnalysis(BaseModel):
      acne: int
      wrinkle: int
      blackhead: int

@app.get("/fastapi/similar-product/{product_id}")
def getSimilarProduct(product_id: int):
    items = pd.read_csv('models/data/products_skinToner.csv',
                        sep=',')
    db = engineconn()
    session = db.sessionmaker()
    items = pd.read_sql_query("SELECT * FROM product", db.engine)

    features = [
        'brand',
        'skin_type_dry',
        'skin_type_combination',
        'skin_type_oily',
        'skin_concerns_moisturizing',
        'skin_concerns_soothing',
        'skin_concerns_wrinkle_whitening',
        'stimulation_mild',
        'stimulation_common',
        'stimulation_hard']

    item_feature = items[features]

    # 문자열 데이터 One-Hot Encoding
    item_feature = pd.get_dummies(item_feature, columns=['brand'])

    # % 데이터 변환
    columns_to_convert = [
        'skin_type_dry',
        'skin_type_combination',
        'skin_type_oily',
        'skin_concerns_moisturizing',
        'skin_concerns_soothing',
        'skin_concerns_wrinkle_whitening',
        'stimulation_mild',
        'stimulation_common',
        'stimulation_hard'
    ]
    item_cleaned = item_feature.fillna(0).astype(int)
    index_for_product_id = items.index[items['id'] == product_id].tolist()[0]
    result = get_cos_sim(index_for_product_id, item_cleaned)
    # 입력으로 들어온 화장품

    columns_to_return = [
        'id', 'name','img_url','brand','avg_rating', 'cnt_rating', 'price', 'capacity'
    ]

    # 유사한 화장품 리스트
    original_data = items.iloc[result][columns_to_return]
    # print(original_data)
    original_data_dict = original_data.to_dict('records')  # 이 부분을 추가
    return original_data_dict

def get_cos_sim(index, item_cleaned, k=5):
   ## get Cosine Similarity
    cosine_sim = cosine_similarity(item_cleaned, item_cleaned)

    ## get similarity scores
    scores = cosine_sim[index]
    print('scores: ', scores)
    ## sort by similarity
    return np.argsort(-scores)[1:k+1]


class SkinDiary(BaseModel):
      acne: int
      wrinkle: int
      age: int
      skinType: str
      faceShape: int
      imgUrl: str

# # SpringBoot로부터 imgUrl을 받아, 피부 분석 결과와 얼굴형을 돌려준다
@app.post("/fastapi/skin-diary")
def getSkinDiary(img_url: ImgUrl):
      print(img_url)
      url = img_url.imgUrl
    

      # 지성 건성 정상을 판단
      skin_type_result = skin_type(url)

      # 피부 분석 결과
      skin_analysis_result = facial_characteristic(url)

      # 얼굴형
      face_shape_result = face_shape(url)

      # 얼굴나이: 공통코드로 return 한다
      face_age_result = facial_age_detection(url)

      return SkinDiary(acne = skin_analysis_result["acne"], wrinkle = skin_analysis_result["wrinkle"],
                       age = face_age_result, skinType = skin_type_result, faceShape = face_shape_result, imgUrl = img_url.imgUrl)

def skin_type(img_url):
    # 결과를 변형해서 반환
    classification = skin_types_image_detection(img_url)

    oily = math.ceil(classification[0]["score"] * 100)
    dry = math.ceil(classification[1]["score"] * 100)
    normal = math.ceil(classification[2]["score"] * 100)

    print(classification)

    type_name = ["OILY", "DRY", "NORMAL"]
    results =[oily, dry, normal]

    if (abs(oily -dry) <= 5):
         if random.random() > 0.5:
              return "OILY"
         else:
              return "DRY"
    else:
         return "NORMAL"

    print(results)

    max_results = max(results)
    index_results = results.index(max_results)

    return type_name[index_results]

def facial_age_detection(img_url):
    
    classification = facial_age_image_detection(img_url)

    weighted_sum = 0
    weights = 0

    for dict in classification:
          age_arr = dict["label"].split("-")
          if len(age_arr) == 2:
            age_mid = (int(age_arr[0]) + int(age_arr[1])) / 2
          elif age_arr[0] == '90+':
            age_mid = 90
          else:
            age_mid = int(age_arr[0])
          weighted_sum += age_mid * dict["score"]
          weights += dict["score"]

    return int(weighted_sum / weights)

def facial_characteristic(img_url):
     result = face_characteristics_classifcation(img_url)
     ans = {"acne": random.randint(1,10), "wrinkle": random.randint(1,10)}
     for obj in result:
        if obj["label"] == "wrinkled face":
             ans["wrinkle"] = int (obj["score"] * 100)
        elif obj["label"] == "acne":
             ans["acne"] = int (obj["score"] * 100)
    
     print(result)
    
     return ans

# def facial_skin_disease_detection(img_url):
#     img_path = tf.keras.utils.get_file('skin_disease', origin=img_url)

#     img = load_img(img_path, target_size=(150, 150))
#     x = img_to_array(img)
#     x /= 255
#     x = np.expand_dims(x, axis=0)

#     images = np.vstack([x])
#     classes = saved_model(images)
#     classes = classes['output_0'].numpy()
#     # print(classes)
#     # classes의 기준을 100으로
#     classes = classes * 100
#     # print(classes)
#     # 각 표기되는 수들을 자연수로
#     classes = np.ceil(classes)
#     # print(classes)
#     classes = classes.astype(int)
#     # print(classes[0][0])

#     return classes


def face_shape(img_url):
    # 결과를 변형해서 반환
    classification = face_shape_classification_pipeline(img_url)

    max_score = 0
    label = ""

    for dict in classification:
          if (dict["score"] > max_score):
                label = dict["label"]
                max_score = dict["score"]



    if label == "Round":
          return 40001
    elif label == "Oblong":
          return 40002
    elif label == "Heart":
          return 40003
    elif label == "Square":
          return 40004
    elif label == "Oval":
          return 40005


class RecommendRequestDto(BaseModel):
     myMemberId: int

class RecommendResponseDto(BaseModel):
     data: list

@app.post("/fastapi/recommendation/all")
def getRecommendationAll(recommendRequestDto: RecommendRequestDto):
    member_id = recommendRequestDto.myMemberId

    with open('all_X.pkl', 'rb') as ax:
         loaded_all_X = pickle.load(ax)
    
    with open('matrix_fact_all.pkl', 'rb') as mfa:
        loaded_matrix_fact_all = pickle.load(mfa)

    items_known = loaded_all_X.query("user_id == @member_id")["item_id"]
    
    # 20개의 제품들을 추천받는다
    recommended = loaded_matrix_fact_all.recommend(user=member_id, amount=20, items_known=items_known)[["item_id", "rating_pred"]]

    print(recommended["item_id"])

    return RecommendResponseDto(data = recommended["item_id"].values.tolist())

@app.post("/fastapi/recommendation/skin-type")
def getRecommendationOily(recommendRequestDto: RecommendRequestDto):
    member_id = recommendRequestDto.myMemberId
    db = engineconn()
    reports = pd.read_sql_query(f"SELECT skin_type FROM report WHERE member_id = {member_id}", db.engine)
    skin_type = reports.values.tolist()[0][0]
    
    loaded_data = None
    loaded_model = None

    if skin_type == "DRY":
         with open('dry_X.pkl', 'rb') as dx:
              loaded_data = pickle.load(dx)
         with open('matrix_fact_dry.pkl', 'rb') as mfd:
              loaded_model = pickle.load(mfd)     
    elif skin_type == "OILY":
         with open('oily_X', 'rb') as ox:
              loaded_data = pickle.load(ox)
         with open('matrix_fact_oily.pkl', 'rb') as mfo:
              loaded_model = pickle.load(mfo)
    else:
         with open('ordinary_X.pkl', 'rb') as ox:
              loaded_data = pickle.load(ox)
         with open('matrix_fact_ordinary.pkl', 'rb') as mfo:
              loaded_model = pickle.load(mfo)
    
    items_known = loaded_data.query("user_id == @member_id")["item_id"]
    
    # 20개의 제품들을 추천받는다
    recommended = loaded_model.recommend(user=member_id, amount=20, items_known=items_known)[["item_id", "rating_pred"]]

    print(recommended["item_id"])

    return RecommendResponseDto(data = recommended["item_id"].values.tolist())

    # return recommended

@app.post("/fastapi/recommendation/age")
def getRecommenationAge(recommendRequestDto: RecommendRequestDto):
    member_id = recommendRequestDto.myMemberId
    db = engineconn()
    age_column = pd.read_sql_query(f"SELECT birthday FROM member WHERE id = {member_id}", db.engine)
    birthdate = age_column.values.tolist()[0][0]

     # 현재 날짜 가져오기 (시뮬레이션)
    current_date = datetime.date.today()

     # 나이 계산
    age = current_date.year - birthdate.year - ((current_date.month, current_date.day) < (birthdate.month, birthdate.day))
    
    if 10 <= age and age <= 20:
         with open('ten_twenty_X.pkl', 'rb') as ttx:
              loaded_data = pickle.load(ttx)
         with open('matrix_fact_ten_twenty', 'rb') as mftt:
              loaded_model = pickle.load(mftt)     
    elif age <= 30:
         with open('twenty_thirty_X.pkl', 'rb') as ttx:
              loaded_data = pickle.load(ttx)
         with open('matrix_fact_twenty_thirty.pkl', 'rb') as mftt:
              loaded_model = pickle.load(mftt)        
    elif age <= 40:
         with open('thirty_fourty_X.pkl', 'rb') as tfx:
              loaded_data = pickle.load(tfx)
         with open('matrix_fact_thirty_fourty.pkl', 'rb') as mfd:
              loaded_model = pickle.load(mfd)         
    elif age > 40:
         with open('fourty_above.pkl', 'rb') as fa:
              loaded_data = pickle.load(fa)
         with open('matrix_fact_fourty_above.pkl', 'rb') as mffa:
              loaded_model = pickle.load(mffa)     
    else:
         with open('others_X.pkl', 'rb') as ox:
              loaded_data = pickle.load(ox)
         with open('matrix_fact_others.pkl', 'rb') as mfo:
              loaded_model = pickle.load(mfo)


    items_known = loaded_data.query("user_id == @member_id")["item_id"]
    
    # 20개의 제품들을 추천받는다
    recommended = loaded_model.recommend(user=member_id, amount=20, items_known=items_known)[["item_id", "rating_pred"]]

    print(recommended["item_id"])

    return RecommendResponseDto(data = recommended["item_id"].values.tolist())
    