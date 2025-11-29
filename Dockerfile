FROM python:3.11-alpine as build
WORKDIR /kubsu
COPY pyproject.toml /kubsu
RUN apk add --no-cache python3-dev py3-pip gcc musl-dev
RUN python -m venv /kubsu/venv
ENV PATH="/kubsu/venv/bin:$PATH"
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir .

FROM python:3.11-alpine
WORKDIR /kubsu
COPY --from=build /kubsu/venv /kubsu/venv
COPY src /kubsu/src
ENV PATH="/kubsu/venv/bin:$PATH"
CMD [ "uvicorn", "src.main:app", "--reload", "--host", "0.0.0.0", "--port", "8051" ]