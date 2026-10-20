package com.codegym.service;
import com.codegym.model.Product; import java.util.*; import java.util.stream.Collectors;
public class ProductServiceImpl implements ProductService {
  private static final Map<Integer,Product> products=new LinkedHashMap<>(); private static int nextId=4;
  static { products.put(1,new Product(1,"Laptop",18500000,"Laptop văn phòng","Dell")); products.put(2,new Product(2,"Điện thoại",12900000,"Điện thoại thông minh","Samsung")); products.put(3,new Product(3,"Tai nghe",1500000,"Tai nghe không dây","Sony")); }
  public List<Product> findAll(){return new ArrayList<>(products.values());}
  public List<Product> findByName(String name){String key=name==null?"":name.toLowerCase();return products.values().stream().filter(p->p.getName().toLowerCase().contains(key)).collect(Collectors.toList());}
  public Product findById(int id){return products.get(id);} public void save(Product p){if(p.getId()==0)p.setId(nextId++);products.put(p.getId(),p);} public void delete(int id){products.remove(id);}
}
