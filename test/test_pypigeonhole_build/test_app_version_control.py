import unittest
import os
import shutil

import pypigeonhole_build.app_version_control as app_version_control


class FileEditorUtilsTest(unittest.TestCase):
    def test_replace_line(self):
        curr_path = os.path.dirname(os.path.abspath(__file__))
        src_file = os.path.join(curr_path, 'sample_file_edit.txt')
        target_file = '/tmp/target_file'
        shutil.copyfile(src_file, target_file)

        new_str = 'You DO! You LIKE US'
        app_version_control.replace_line(target_file, 'I DO! I LIKE THEM', new_str)

        with open(target_file, 'r') as f:
            lines = f.read()
            self.assertTrue(lines.find(new_str) > -1)

        os.remove(target_file)

    def test_version_inc(self):
        self.assertTrue(app_version_control.version_inc_upto10('1.2.3') == '1.2.4')
        self.assertTrue(app_version_control.version_inc_upto10('1.2.9') == '1.3.0')
        self.assertTrue(app_version_control.version_inc_upto10('1.9.9') == '2.0.0')

        self.assertTrue(app_version_control.version_inc_upto100('1.2.3') == '1.2.4')
        self.assertTrue(app_version_control.version_inc_upto100('1.2.99') == '1.3.0')
        self.assertTrue(app_version_control.version_inc_upto100('1.99.99') == '2.0.0')

        self.assertTrue(app_version_control.version_inc_upto10('1.2.3') == '1.2.4')
        self.assertTrue(app_version_control.version_inc_inf('1.9.9') == '1.9.10')
        self.assertTrue(app_version_control.version_inc_inf('1.9.99') == '1.9.100')

    def test_bump_version(self):
        tmp_file = '/tmp/test1'
        v = '1.2.3'
        with open(tmp_file, 'w') as f:  # open a tmp file, save 1.2.3 in it.
            f.write('__app_version = ' + v)

        app_version_control.bump_version_upto10(v, tmp_file)  # bump 1.2.3 to 1.2.4
        app_version_control.bump_version_upto100('1.2.4', tmp_file)  # bump 1.2.4 to 1.2.5
        app_version_control.bump_version_inf('1.2.5', tmp_file)  # bump 1.2.5 to 1.2.6

        with open(tmp_file, 'r') as f:
            line = f.readline()
            self.assertTrue(line.strip() == '__app_version = "1.2.6"')

        # os.remove(tmp_file)
