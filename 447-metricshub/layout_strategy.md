# Layout strategy
Navbar dùng Flexbox để căn giữa theo một trục. Dashboard dùng CSS Grid dạng Bento nhằm điều khiển đồng thời hàng và cột. Pricing dùng Bootstrap Grid với `col-12 col-md-4`, nhờ đó ba gói dịch vụ tự chuyển từ một cột trên mobile sang ba cột từ breakpoint `md`. Sidebar và nội dung chính dùng Grid hai cột trên desktop; media query chuyển về một cột trên màn hình nhỏ.
