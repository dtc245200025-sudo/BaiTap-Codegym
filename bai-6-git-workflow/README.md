# Bài 6 — Mô phỏng quy trình làm việc với Git

Trang giới thiệu cá nhân đơn giản gồm `index.html` và `style.css`.

## Xem bài

Mở `index.html` trong trình duyệt. Giao diện có phần giới thiệu bản thân, danh sách kiến thức đang học và bố cục thích ứng với màn hình nhỏ.

## Phạm vi thực hiện

Theo yêu cầu nộp vào repository có sẵn `BaiTap-Codegym`, bài được làm trên nhánh riêng `bai-6-git-workflow`, trong thư mục cùng tên. Repository được clone về máy (Git tạo repository local khi clone), giữ remote `origin` và lịch sử cũ; không tạo repository GitHub mới như đề mẫu. Nhánh `main` không bị thay đổi.

## Quá trình thực hành

1. Tạo nhánh `bai-6-git-workflow` từ `main`.
2. Tạo hai file HTML/CSS ban đầu → commit `Initial structure` → push và thiết lập upstream.
3. Thêm phần giới thiệu bản thân → commit `Add introduction section` → push.
4. Thêm CSS cho phần giới thiệu → commit `Style introduction section` → push.
5. Cố tình thêm `.introduction { display: none; }` làm mất phần giới thiệu → commit `Introduce incorrect CSS for revert practice`.
6. Chạy `git revert --no-edit HEAD` để tạo commit đảo ngược lỗi. Các commit hợp lệ vẫn được giữ nguyên.
7. Push bản cuối và bổ sung tài liệu nộp bài.

## Lệnh kiểm tra

Chạy trong thư mục gốc repository:

```sh
git switch bai-6-git-workflow
git log --oneline main..HEAD
git show 5c3525b
git show efb1945
git remote -v
git status
```

Commit hoàn tác khôi phục hai file HTML/CSS giống hệt commit `Style introduction section`. Kiểm tra bằng:

```sh
git diff 5c3525b HEAD -- bai-6-git-workflow/index.html bai-6-git-workflow/style.css
```

Kết quả không có diff nghĩa là nội dung trang đã trở lại bản đúng.

## Vì sao dùng revert?

`git revert` tạo commit mới đảo ngược thay đổi của commit sai, giữ lại lịch sử để người khác kiểm tra. Phù hợp khi lịch sử đã được chia sẻ trên GitHub. `git reset --hard` thay đổi vị trí nhánh và loại bỏ thay đổi trong staging/working directory; nếu ép đẩy lịch sử đã lùi lên remote, người cùng làm có thể gặp lệch lịch sử. Bài này không cần force-push.

