from sqlalchemy import Column, ForeignKey, BigInteger, String, Float, Text, Boolean, Integer
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class CommonCode(Base):
    __tablename__ = 'common_code'
    code = Column(Integer, primary_key=True)
    parentCode = Column(Integer)
    codeName = Column(String)
    # CommonCode 클래스에 대한 다른 필드와 관계는 여기에 정의해야 합니다.

class Product(Base):
    __tablename__ = 'product'
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    category_code = Column(BigInteger, ForeignKey('common_code.id'))
    category = relationship("CommonCode", lazy="joined")
    avg_rating = Column(Float, default=0.0)
    cnt_rating = Column(Integer, default=0)
    goods_no = Column(String)
    name = Column(String)
    img_url = Column(String)
    brand = Column(String)
    price = Column(Integer)
    capacity = Column(String)
    main_point = Column(String)
    use_date = Column(String)
    how_use = Column(Text)
    material = Column(Text)
    link_url = Column(Text)
    skin_type_dry = Column(String)
    skin_type_combination = Column(String)
    skin_type_oily = Column(String)
    skin_concerns_moisturizing = Column(String)
    skin_concerns_soothing = Column(String)
    skin_concerns_wrinkle_whitening = Column(String)
    stimulation_mild = Column(String)
    stimulation_common = Column(String)
    stimulation_hard = Column(String)
    is_quasi_drug = Column(Boolean)
    imgList = relationship("ProductImage", order_by="ProductImage.img_seq", back_populates="product")


class ProductImage(Base):
    __tablename__ = 'product_image'
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    img_url = Column(String)
    img_seq = Column(String)  # imgSeq 필드, SQLAlchemy에서는 snake_case를 권장합니다.
    product_id = Column(BigInteger, ForeignKey('product.id'))

    product = relationship("Product", back_populates="imgList")
