class TreeNode{
  private int id;
  private float value;
  private TreeNode left;
  private TreeNode right;
  private TreeNode parent;
  private TreeNode child;
  private boolean isLeaf;
  private float offset;
  private float rect_x1;
  private float rect_x2;
  private float rect_y1;
  private float rect_y2;
  private float rect_w;
  private float rect_h;
  private float rect_area;
  
  
  
  public TreeNode(int _id, float _value){
    id  = _id;
    value = _value;
    
    left   = null;
    right  = null;
    parent = null;
    child  = null;
    
    offset    =  0;
    rect_x1   = -1;
    rect_x2   = -1;
    rect_y1   = -1;
    rect_y2   = -1;
    rect_w    = -1;
    rect_h    = -1;
    rect_area = -1;
  }
  
  public int getID(){
    return id;
  }
  
  public float getValue(){
    return value;
  }
  
  public void setValue(float _value){
    value = _value;
  }
  
  public TreeNode getChildNode(){
      return child;
  }
  
  public void setChildNode(TreeNode _child){
    child = _child;
  }
  
   public TreeNode getParentNode(){
      return parent;
  }
  
  public void setParentNode(TreeNode _parent){
    parent = _parent;
  }
  
  public TreeNode getRightNode(){
    return right;
  }
  
  public void setRightNode(TreeNode _right){
    right = _right;
  }
 
  public TreeNode getLeftNode(){
    return left;
  }
  
  public void setLeftNode(TreeNode _left){
    left = _left;
  }
  
  public void setOffset(float _offset){
    offset = _offset;
  }
  
  public float getOffset(){
    return offset;
  }
  
  public float getX1(){
    return rect_x1 + (offset * rect_w);
  }
  
  public void setX1(float x1){
    rect_x1 = x1;
    rect_w  = rect_x2 - rect_x1;
  }
  
   public float getX2(){
    return rect_x2 - (offset * rect_w); 
  }
  
  public void setX2(float x2){
    rect_x2 = x2;
    rect_w  = rect_x2 - rect_x1;
  }
  
   public float getY1(){
    return rect_y1 + (offset * rect_h);
  }
  
  public void setY1(float y1){
    rect_y1 = y1;
    rect_h  = rect_y2 - rect_y1;
  }
  
   public float getY2(){
    return rect_y2 - (offset * rect_h);
  }
  
  public void setY2(float y2){
    rect_y2 = y2;
    rect_h  = rect_y2 - rect_y1;
  }
  
}
