import unittest
import os
import shutil

import pypigeonhole_build.file_edit_utils as file_edit_utils


class FileEditorUtilsTest(unittest.TestCase):
    def test_replace_line(self):
        curr_path = os.path.dirname(os.path.abspath(__file__))
        src_file = os.path.join(curr_path, 'sample_file_edit.txt')
        target_file = '/tmp/target_file'
        shutil.copyfile(src_file, target_file)

        new_str = 'You DO! You LIKE US'
        file_edit_utils.replace_line(target_file, 'I DO! I LIKE THEM', new_str)

        with open(target_file, 'r') as f:
            lines = f.read()
            self.assertTrue(lines.find(new_str) > -1)

        os.remove(target_file)

    def test_version_inc(self):
        self.assertTrue(file_edit_utils.version_inc_1('1.2.3') == '1.2.4')
        self.assertTrue(file_edit_utils.version_inc_1('1.2.9') == '1.3.0')
        self.assertTrue(file_edit_utils.version_inc_1('1.9.9') == '2.0.0')

        self.assertTrue(file_edit_utils.version_inc_1('1.2.3') == '1.2.4')
        self.assertTrue(file_edit_utils.version_inc_2('1.9.9') == '1.9.10')
        self.assertTrue(file_edit_utils.version_inc_2('1.9.15') == '1.9.16')

    def test_bump_version(self):
        tmp_file = '/tmp/test1'
        v = '1.2.3'
        with open(tmp_file, 'w') as f:  # open a tmp file, save 1.2.3 in it.
            f.write('app_version=' + v)

        file_edit_utils.bump_version1(v, tmp_file)  # bump 1.2.3 to 1.2.4
        file_edit_utils.bump_version2('1.2.4', tmp_file)  # bump 1.2.4 to 1.2.5

        with open(tmp_file, 'r') as f:
            line = f.readline()
            self.assertTrue(line.strip() == 'app_version = "1.2.5"')

        os.remove(tmp_file)
