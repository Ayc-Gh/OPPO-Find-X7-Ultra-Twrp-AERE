from pathlib import Path
import urllib.request,tarfile,hashlib,json
base=Path('/aera/work-browser')
commit='1a0073f0322c8b74cbcb75ca1bb1c3d19d75538d'
archive=base/('openh264-'+commit+'.tar.gz')
url='https://codeload.github.com/cisco/openh264/tar.gz/'+commit
if not archive.exists(): archive.write_bytes(urllib.request.urlopen(url,timeout=60).read())
assert hashlib.sha256(archive.read_bytes()).hexdigest()=='3e021e6046dcd79f70fa7842896a85cb2205575ea6170db023c4318fafcb0040', 'Pinned source archive checksum mismatch'
with tarfile.open(archive) as tf: tf.extractall(base,filter='data')
print(json.dumps({'commit':commit,'archive_sha256':hashlib.sha256(archive.read_bytes()).hexdigest(),'url':url}),flush=True)
