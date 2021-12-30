########## IMAN ALI ##########
########## imaali ##############
########## 112204305 #############
import re

def is_pwd_strong(password):
    if len(password) < 8:
        return None
    return re.search(r"(?=.*[\d])(?=.*[A-Z])(?=.*[a-z])", password)
