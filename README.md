**Build the image**
```bash
docker build -t "rar:latest" .
```

**Set the password**
```bash
docker run -e PASSWORD=pass -p 8787:8787 rar:latest
```

**Run the container**
```bash
docker run -v $(pwd)/data:/root/data -it --rm rar:latest /bin/bash
```

**Check installed R packages**
```bash
ip = as.data.frame(installed.packages()[,c(1,3:4)])
ip = ip[is.na(ip$Priority),1:2,drop=FALSE]
ip
```

**Check LaTeX version**
```bash
pdflatex --version
```
