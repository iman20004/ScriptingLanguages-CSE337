import unittest
import os
import sys
sys.path.insert(1,os.getcwd())
from pwd_strength_detect import *

class PwdStrengthDetect(unittest.TestCase):

    def test_pwd_uppercase_absent_weak(self):
        pwd = 'hiri21baba@'
        self.assertIsNone(is_pwd_strong(pwd), "Expected no match since password has no upper case")

    def test_pwd_digit_absent_weak(self):
        pwd = 'hiri$baba@'
        self.assertIsNone(is_pwd_strong(pwd), "Expected no match since password has no digits")

    def test_pwd_empty_weak(self):
        pwd = ''
        self.assertIsNone(is_pwd_strong(pwd), "Expected no match since password is empty")

    def test_pwd_lowercase_absent_weak(self):
        pwd = 'HIRI$BAAB1@9'
        self.assertIsNone(is_pwd_strong(pwd), "Expected no match since password has no lowercase")

    def test_pwd_short_weak(self):
        pwd = 'Hri$19!'
        self.assertIsNone(is_pwd_strong(pwd), "Expected no match since password has less than 8 chars")

    def test_pwd_strong_1(self):
        pwd = 'haSH$71q!'
        s = is_pwd_strong(pwd)
        self.assertIsNotNone(s, "Expected a match!")
        self.assertTrue(isinstance(s, re.Match), "Expected an instance of match!")

    def test_pwd_strong_2(self):
        pwd = '$iMba22&3kaki'
        s = is_pwd_strong(pwd)
        self.assertIsNotNone(s, "Expected a match!")
        self.assertTrue(isinstance(s, re.Match), "Expected an instance of match!")

    def test_pwd_strong_3(self):
        pwd = 'M@mBO9JAMB0'
        s = is_pwd_strong(pwd)
        self.assertIsNotNone(s, "Expected a match!")
        self.assertTrue(isinstance(s, re.Match), "Expected an instance of match!")

    def test_pwd_strong_4(self):
        pwd = '1889@Tu.gnI'
        s = is_pwd_strong(pwd)
        self.assertIsNotNone(s, "Expected a match!")
        self.assertTrue(isinstance(s, re.Match), "Expected an instance of match!")

    def test_pwd_strong_5(self):
        pwd = '18)@Tu().gnI<>'
        s = is_pwd_strong(pwd)
        self.assertIsNotNone(s, "Expected a match!")
        self.assertTrue(isinstance(s, re.Match), "Expected an instance of match!")
