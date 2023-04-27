from pydantic import BaseModel


class GAN(BaseModel):
   type : int
   image : str