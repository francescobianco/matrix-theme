

push:
	@git add .
	@git commit -am "New Release!" || true
	@git push