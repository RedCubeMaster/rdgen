FROM python:3.13-alpine

# 1. Creamos el usuario
RUN adduser -D user

# 2. Definimos la carpeta de trabajo (esto la crea en el sistema)
WORKDIR /opt/rdgen

# 3. Copiamos todos los archivos de tu repositorio a la carpeta
COPY . .

# 4. Le damos la propiedad total de la carpeta al usuario "user"
RUN chown -R user:user /opt/rdgen

# 5. AHORA SÍ, nos cambiamos al usuario limitado
USER user

# 6. Como ya somos el usuario limitado y somos dueños de la carpeta, instalamos Python
RUN pip install --no-cache-dir -r requirements.txt \
 && python manage.py migrate

ENV PYTHONUNBUFFERED=1

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD wget --spider 0.0.0.0:8000

CMD ["/home/user/.local/bin/gunicorn", "-c", "gunicorn.conf.py", "rdgen.wsgi:application"]
