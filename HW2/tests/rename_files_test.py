import unittest
import os
import sys
import shutil
sys.path.insert(1,os.getcwd())
from rename_files import *

class RenameFilesTest(unittest.TestCase):

    def setUp(self):
        if os.path.isdir('tmp'):
            shutil.rmtree('tmp')
        else:
            os.mkdir('tmp')

    def tearDown(self):
        if os.path.isdir('tmp'):
            shutil.rmtree('tmp')

    def test_dir_absent(self):
        self.assertEqual("tmp1 does not exist!", rename('tmp1'))

    def test_dir_empty(self):
        rename('tmp')
        self.assertTrue(len(os.listdir('tmp')) == 0)

    def test_dir_empty_1(self):
        with open(os.path.join('tmp', 'bsnap001.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'csnap002.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'dsnap002.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'esnap002.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'fsnap002.txt'), 'w+') as f:
            f.write('A file')
        rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'bsnap001.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'csnap002.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'dsnap002.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'esnap002.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'fsnap002.txt')))

    def test_dir_no_gap(self):
        with open(os.path.join('tmp', 'snap001.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap002.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap003.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap004.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap005.txt'), 'w+') as f:
            f.write('A file')
        rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap001.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap002.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap003.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap004.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap005.txt')))

    def test_dir_bad_inputs(self):
        with open(os.path.join('tmp', 'snap001.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap002.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap004.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap005.txt'), 'w+') as f:
            f.write('A file')
        os.mkdir(os.path.join('tmp', 'snap003.txt'))
        with self.assertRaises(ValueError):
            rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap001.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap002.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap004.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap005.txt')))
        self.assertTrue(os.path.isdir(os.path.join('tmp', 'snap003.txt')))

    def test_dir_gap_1(self):
        with open(os.path.join('tmp', 'snap001.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap002.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap004.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap003.txt'), 'w+') as f:
            f.write('A file')
        rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap001.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap002.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap003.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap004.txt')))
        self.assertFalse(os.path.isfile(os.path.join('tmp', 'snap005.txt')))

    def test_dir_gap_2(self):
        with open(os.path.join('tmp', 'snap001.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap002.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap004.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap005.txt'), 'w+') as f:
            f.write('A file')
        os.mkdir(os.path.join('tmp', 'snap006.txt'))
        rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap001.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap002.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap003.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap004.txt')))
        self.assertFalse(os.path.isfile(os.path.join('tmp', 'snap005.txt')))
        self.assertTrue(os.path.isdir(os.path.join('tmp', 'snap006.txt')))

    def test_dir_gap_3(self):
        with open(os.path.join('tmp', 'snap001.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap002.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snp003.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap004.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap005.txt'), 'w+') as f:
            f.write('A file')
        rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap001.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap002.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap003.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap004.txt')))
        self.assertFalse(os.path.isfile(os.path.join('tmp', 'snap005.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snp003.txt')))

    def test_dir_gap_4(self):
        with open(os.path.join('tmp', 'snap001.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap002.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snp003.jpg'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap004.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap005.txt'), 'w+') as f:
            f.write('A file')
        rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap001.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap002.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap003.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap004.txt')))
        self.assertFalse(os.path.isfile(os.path.join('tmp', 'snap005.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snp003.jpg')))

    def test_dir_gap_5(self):
        with open(os.path.join('tmp', 'snap001.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap003.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap003.jpg'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap004.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap005.txt'), 'w+') as f:
            f.write('A file')
        rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap001.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap002.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap003.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap004.txt')))
        self.assertFalse(os.path.isfile(os.path.join('tmp', 'snap005.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap003.jpg')))

    def test_dir_gap_5(self):
        with open(os.path.join('tmp', 'snap001.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap002.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap03.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap004.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap005.txt'), 'w+') as f:
            f.write('A file')
        rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap001.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap002.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap003.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap004.txt')))
        self.assertFalse(os.path.isfile(os.path.join('tmp', 'snap005.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap03.txt')))

    def test_dir_gap_6(self):
        with open(os.path.join('tmp', 'snap008.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap009.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap011.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap013.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap014.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap015.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap016.txt'), 'w+') as f:
            f.write('A file')
        rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap008.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap009.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap010.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap011.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap012.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap013.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap014.txt')))

    def test_dir_gap_7(self):
        with open(os.path.join('tmp', 'snap008.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap009.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap011.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap013.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap014.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap015.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap016.txt'), 'w+') as f:
            f.write('A file')
        rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap008.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap009.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap010.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap011.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap012.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap013.txt')))
        self.assertFalse(os.path.isfile(os.path.join('tmp', 'snap015.txt')))
        self.assertFalse(os.path.isfile(os.path.join('tmp', 'snap016.txt')))

    def test_dir_gap_8(self):
        with open(os.path.join('tmp', 'snap991.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap992.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap993.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap994.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap996.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap998.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap999.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap1000.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap1001.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap2000.txt'), 'w+') as f:
            f.write('A file')
        rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap991.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap992.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap993.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap994.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap995.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap996.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap997.txt')))
        self.assertFalse(os.path.isfile(os.path.join('tmp', 'snap998.txt')))
        self.assertFalse(os.path.isfile(os.path.join('tmp', 'snap999.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap1000.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap1001.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap2000.txt')))

    def test_dir_gap_9(self):
        with open(os.path.join('tmp', 'snap1000.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap1001.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap1003.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap1004.txt'), 'w+') as f:
            f.write('A file')
        rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap1000.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap1001.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap1003.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap1004.txt')))

    def test_dir_gap_10(self):
        with open(os.path.join('tmp', 'snap008.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap009.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap010.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap014.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap015.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap016.txt'), 'w+') as f:
            f.write('A file')
        rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap008.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap009.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap010.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap011.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap012.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap013.txt')))

    def test_dir_gap_11(self):
        with open(os.path.join('tmp', 'snap008.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap009.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap010.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap014.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap015.txt'), 'w+') as f:
            f.write('A file')
        with open(os.path.join('tmp', 'snap020.txt'), 'w+') as f:
            f.write('A file')
        rename('tmp')
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap008.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap009.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap010.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap011.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap012.txt')))
        self.assertTrue(os.path.isfile(os.path.join('tmp', 'snap013.txt')))
