# Create new v
docker volume create mssql-storage

Перевірити підключений том можна командою:
docker inspect -f '{{ .Mounts }}' mssql-study
# Run container
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Dbnpswwd2" -v
mssql-storage:/var/opt/mssql -p 1433:1433 --name mssql-study -d
mcr.microsoft.com/mssql/server:2022-latest