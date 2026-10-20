package com.codegym.controller;
import com.codegym.model.Product; import com.codegym.service.*; import jakarta.servlet.*; import jakarta.servlet.annotation.WebServlet; import jakarta.servlet.http.*; import java.io.IOException;
@WebServlet("/products") public class ProductServlet extends HttpServlet {
  private final ProductService service=new ProductServiceImpl();
  protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
    String action=req.getParameter("action"); if(action==null)action="list";
    switch(action){
      case "create" -> req.getRequestDispatcher("/product/form.jsp").forward(req,resp);
      case "edit" -> showProduct(req,resp,"/product/form.jsp");
      case "view" -> showProduct(req,resp,"/product/view.jsp");
      case "delete" -> {service.delete(Integer.parseInt(req.getParameter("id")));resp.sendRedirect("products");}
      case "search" -> {req.setAttribute("products",service.findByName(req.getParameter("name")));req.getRequestDispatcher("/product/list.jsp").forward(req,resp);}
      default -> {req.setAttribute("products",service.findAll());req.getRequestDispatcher("/product/list.jsp").forward(req,resp);}
    }
  }
  private void showProduct(HttpServletRequest req,HttpServletResponse resp,String view)throws ServletException,IOException{Product p=service.findById(Integer.parseInt(req.getParameter("id")));if(p==null){resp.sendError(404);return;}req.setAttribute("product",p);req.getRequestDispatcher(view).forward(req,resp);}
  protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws IOException{req.setCharacterEncoding("UTF-8");String id=req.getParameter("id");double price=Double.parseDouble(req.getParameter("price"));service.save(new Product(id==null||id.isBlank()?0:Integer.parseInt(id),req.getParameter("name"),price,req.getParameter("description"),req.getParameter("manufacturer")));resp.sendRedirect("products");}
}
