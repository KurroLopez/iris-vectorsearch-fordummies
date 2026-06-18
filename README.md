# Example of Vector search Usage

## Download the code from GitHub

To download the code from GitHub, follow these steps:

1. Clone the repository from GitHub:
    ```bash
    git clone https://github.com/KurroLopez/iris-vectorsearch-fordummies
    ```
2. Navigate to the project directory:
    ```bash
    cd iris-vectorsearch-fordummies
    ```
3. Build and start the Docker containers:
    ```bash
    docker-compose build --no-cache
    docker-compose up -d
    ```

## Open IRIS portal
[http://localhost:52773/csp/sys/UtilHome.csp](http://localhost:52773/csp/sys/UtilHome.csp)

- User: superuser
- Pass: sys

## Open the IRIS terminal

To open the IRIS terminal and initialize the example classes, follow these steps:

```
docker-compose exec iris iris session iris
```

**Example of feeling search:**

[http://localhost:52773/csp/user/feeling.html](http://localhost:52773/csp/user/feeling.html)

**Example of movies search:**

[http://localhost:52773/csp/user/movies.html](http://localhost:52773/csp/user/movies.html)
