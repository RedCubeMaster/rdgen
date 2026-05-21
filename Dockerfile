FROM python:3.13-alpine

RUN adduser -D user
WORKDIR /opt/rdgen

COPY . .

# Creamos la carpeta manualmente y abrimos todos los candados de escritura (777)
RUN mkdir -p temp_zips \
 && chown -R user:user /opt/rdgen \
 && chmod -R 777 temp_zips

USER user

RUN pip install --no-cache-dir -r requirements.txt \
 && python manage.py migrate

ENV PYTHONUNBUFFERED=1

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD wget --spider 0.0.0.0:8000

CMD ["/home/user/.local/bin/gunicorn", "-c", "gunicorn.conf.py", "rdgen.wsgi:application"]
