#!/usr/bin/env python3

import subprocess, os, base64, sys, json

FNULL = open(os.devnull, "w")
html = open("template.html").read()
html2 = open("template-2.html").read()
fname = "file://" + os.getcwd() + "/index.html"

def clean(fname):
	try:
		os.remove(fname)
	except:
		pass

data = {}

for i in " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789ÀÁẢÃẠĂẰẮẲẴẶÂẦẤẨẪẬàáảãạăằắẳẵặâầấẩẫậĐđÈÉẺẼẸÊỀẾỂỄỆèéẻẽẹêềếểễệÌÍỈĨỊìíỉĩịÒÓỎÕỌÔỒỐỔỖỘƠỜỚỞỠỢòóỏõọôồốổỗộơờớởỡợÙÚỦŨỤƯỪỨỬỮỰùúủũụưừứửữựỲÝỶỸỴỳýỷỹỵ":
	print (i)
	clean("screenshot.png")
	if i != ' ':
		open("index.html", "wt").write(html.replace("XXX", i))
	else:
		open("index.html", "wt").write(html2)
	subprocess.call(["chromium", "--headless", "--disable-gpu", "--screenshot", fname], stderr = FNULL)
	if not os.path.exists("screenshot.png"):
		print ("error")
		sys.exit(1)
	subprocess.call(["convert", "-trim", "screenshot.png", "screenshot.png"])
	data[i] = base64.b64encode(open("screenshot.png", "rb").read()).decode("utf-8")
	# sys.exit(0)
	clean("index.html")
	clean("screenshot.png")

dst = "./font_default.json"
open(dst, "wt").write(json.dumps(data))
print ("data written to " + dst)
