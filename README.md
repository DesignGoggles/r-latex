**Build the image**
```bash
docker build -t "rar-1:latest" .
```

**Set the password**
```bash
docker run -e PASSWORD=pass -p 8787:8787 rar-1:latest
```

**Run the container**
```bash
docker run -ti --rm rar-1:latest /bin/bash
```