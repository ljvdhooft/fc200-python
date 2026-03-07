import gzip
import sys
import os
import shutil
import xmltodict

def reduce_version(file_path):
    if not os.path.exists(file_path):
        print(f"Error: File '{file_path}' not found.")
        return

    try:
        with gzip.open(file_path, 'rb') as f:
            xml_content = xmltodict.parse(f.read())

        bak_path = file_path + ".bak"
        shutil.copy2(file_path, bak_path)

        xml_content['Ableton']['@MinorVersion'] = "12.0_12300"
        xml_content['Ableton']['@Creator'] = "Ableton Live 12.3.5"
        xml_content['Ableton']['@Revision'] = "c4ac4719dc031414ac6b814d56d1c6c8690febb3"

        xml_output = xmltodict.unparse(xml_content)

        with gzip.open(file_path, 'wb', compresslevel=9) as f:
            f.write(xml_output.encode('UTF-8'))


    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 backwards-compatible.py <file.als>")
    else:
        reduce_version(sys.argv[1])
