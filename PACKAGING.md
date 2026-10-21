# Thực hành đóng gói thư viện Java

Repository chứa hai dự án Maven:

- `math-lib`: thư viện phép tính, đóng gói thành `math-lib.jar`.
- `calculator-app`: ứng dụng sử dụng thư viện qua thư mục `lib`.

## Chạy thử

```bash
cd math-lib
mvn clean package
cp target/math-lib-1.0.jar ../calculator-app/lib/math-lib.jar
cd ../calculator-app
mvn clean package
java -cp "target/classes;lib/math-lib.jar" com.codegym.Main
```
