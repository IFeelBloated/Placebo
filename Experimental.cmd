ECHO LWLibAVVideoSource ("search.mkv") > temp.avs
ECHO EdgeCleanse16 (tv_range=false) >> temp.avs
call x264.exe --output cleanse.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi
