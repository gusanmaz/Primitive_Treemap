public class Tree{
  private LeafData[] leafData;
  private NonLeafData[] nonLeafData;
  private TreeNode[] leafNodes;
  private TreeNode[] nonLeafNodes;
  private TreeNode rootNode;
  private int rootID;
  private int leafCnt;
  private int nonLeafCnt;
  
  private int leafNodeSize;
  private int nonLeafNodeSize;
  
  public Tree(LeafData[] _leafData, NonLeafData[] _nonLeafData, int _rootID){
    leafData     = _leafData;
    nonLeafData  = _nonLeafData;
    leafCnt      = leafData.length;
    leafNodes    = new TreeNode[leafCnt];
    nonLeafCnt   = nonLeafData.length;
    nonLeafNodes =  new TreeNode[nonLeafCnt - leafCnt + 1];
    rootID       = _rootID;
    leafNodeSize =   0;
    nonLeafNodeSize = 0;

    for(int i = 0; i < leafCnt; i++){
      insertNode(leafData[i].id);
    }

     for(int i = 0; i < nonLeafCnt; i++){
      connect(nonLeafData[i].parentID, nonLeafData[i].childID);
    }

    //Assuming root element is not also a leaf.
    rootNode = findNode(rootID, false);
  }


  public void squarify(float w, float h){
    float bigger = (w>h) ? w:h;
    w /= bigger;
    h /= bigger;
    rootNode.setX1(0);
    rootNode.setY1(0);
    rootNode.setX2(w);
    rootNode.setY2(h);
    
    calculateValues(rootNode);
    sortAllNodes(rootNode);
    divideTree2Squares(rootNode.getChildNode());
  }

  public TreeNode[] getLeafNodes(){
    return leafNodes;
  }
  
  private TreeNode sortNodes(TreeNode node){
      TreeNode sortedList = node;
      TreeNode unsortedList = node.getRightNode();
      sortedList.setRightNode(null);
      
      if (unsortedList != null)
        unsortedList.setLeftNode(null);
      
      while (unsortedList != null){
        TreeNode node2Insert = unsortedList;
        TreeNode nextNode2Insert = unsortedList.getRightNode(); // newly inserted
        float node2InsertVal = node2Insert.getValue();
        TreeNode movingNode  = sortedList;
        
        while (movingNode != null){
          if (movingNode.getValue() < node2InsertVal){ // < Default
            TreeNode oldNodeLeft = movingNode.getLeftNode();
            
            if (oldNodeLeft != null){
              oldNodeLeft.setRightNode(node2Insert);
              movingNode.setLeftNode(node2Insert);
              node2Insert.setLeftNode(oldNodeLeft);
              node2Insert.setRightNode(movingNode);
            }
            else{
              movingNode.setLeftNode(node2Insert);
              node2Insert.setLeftNode(null);
              node2Insert.setRightNode(movingNode);
              
              TreeNode p = sortedList.getParentNode();
              p.setChildNode(node2Insert);
              sortedList = node2Insert;
            }
            
            unsortedList = nextNode2Insert;
            if (unsortedList != null)
              unsortedList.setLeftNode(null);
            break;
          }
          
          else if (movingNode.getRightNode() == null){
            unsortedList = nextNode2Insert;
            if (unsortedList != null){
              unsortedList.setLeftNode(null);
            }
            movingNode.setRightNode(node2Insert);
            node2Insert.setLeftNode(movingNode);
            node2Insert.setRightNode(null);
            break;
          }
            
          else{
            movingNode = movingNode.getRightNode();
          }
        }
      }
      return sortedList;
  }
  
  private void sortAllNodes(TreeNode node){
    if (node.getChildNode() != null){
      sortNodes(node.getChildNode());
      TreeNode movingNode = node.getChildNode();
      while (movingNode != null){
        sortAllNodes(movingNode);
        movingNode = movingNode.getRightNode();
      }
    }
    else{
      return;
    }
  }
  
  private void divideList2Squares(TreeNode node, float sum, float x1, float y1, float x2, float y2){
    float h = y2 - y1;
    float w = x2 - x1;
    TreeNode firstNode2Process = node;
    TreeNode leftNode, rightNode;
    
    float cur_sum  = sum;
    float cur_h    = h;
    float cur_w    = w;
    float cur_x1   = x1;
    float cur_x2   = x2;
    float cur_y1   = y1;
    float cur_y2   = y2;
    
    while(firstNode2Process != null){
      //Horizontal Division
      if (cur_h > cur_w){
         leftNode = rightNode = firstNode2Process;
         float vals_sum = 0;
         float old_proportion;
         float new_proportion = 1;
         
         do{
           float nodeVal = rightNode.getValue();
           vals_sum += nodeVal;
           float used_h = (vals_sum / cur_sum) * cur_h;
           float used_w = (nodeVal / vals_sum) * cur_w; 
           old_proportion = new_proportion;
           if (used_w > used_h)
             new_proportion = 1 - (used_h / used_w);
           else
             new_proportion = 1 - (used_w / used_h);
             
           rightNode = rightNode.getRightNode();
         }while((new_proportion < old_proportion) && (rightNode != null));
         
         
         
         if (rightNode != null){
           rightNode = rightNode.getLeftNode();
           vals_sum  -= rightNode.getValue();
           rightNode = rightNode.getLeftNode();
         }
         
         else{
           rightNode = leftNode;
           while (rightNode.getRightNode() != null){
             rightNode = rightNode.getRightNode();
           }
           if (new_proportion > old_proportion){
             vals_sum  -= rightNode.getValue();
             rightNode = rightNode.getLeftNode();
           }
         }
         
         float outer_x1 = cur_x1;
         float outer_y1 = cur_y1;
         float outer_x2 = cur_x2;
         float outer_y2 = cur_y1 + ((cur_y2 - cur_y1) * (vals_sum / cur_sum));
         float outer_w  = (outer_x2 - outer_x1);
         float outer_h  = (outer_y2 - outer_y1);
         
         float x1_mem = outer_x1;
         TreeNode movingNode = leftNode;
         
         while (movingNode != rightNode.getRightNode()){
           float squareVal = movingNode.getValue();
           float valScaled = (squareVal / vals_sum);
           float xx2        = x1_mem + (valScaled * outer_w);
           
           movingNode.setX1(x1_mem);
           movingNode.setY1(outer_y1);
           movingNode.setX2(xx2);
           movingNode.setY2(outer_y2);
           
           x1_mem = xx2;
           movingNode = movingNode.getRightNode();
         }
         
         cur_sum -= vals_sum;
         cur_y1  = outer_y2;
         cur_h   = cur_y2 - cur_y1;
         
         firstNode2Process = movingNode;
      }
      
      //Vertical Division
      else{
         leftNode = rightNode = firstNode2Process;
         float vals_sum = 0;
         float old_proportion;
         float new_proportion = 1;
         int i = 0;
         
         do{
           float nodeVal = rightNode.getValue();
           vals_sum += nodeVal;
           float used_w = (vals_sum / cur_sum) * cur_w;
           float used_h = (nodeVal / vals_sum) * cur_h;
           old_proportion = new_proportion;
           
           if (used_w > used_h)
             new_proportion  = 1 - (used_h / used_w);
           else
              new_proportion = 1 - (used_w / used_h);
              
           rightNode = rightNode.getRightNode();
         }while((new_proportion < old_proportion) && (rightNode != null));
         
         
         if (rightNode != null){
           rightNode = rightNode.getLeftNode();
           vals_sum  -= rightNode.getValue();
           rightNode = rightNode.getLeftNode();
         }
         
         else{
           rightNode = leftNode;
           while (rightNode.getRightNode() != null){
             rightNode = rightNode.getRightNode();
           }
           if (new_proportion > old_proportion){
             vals_sum  -= rightNode.getValue();
             rightNode = rightNode.getLeftNode();
           }
         }
         
         float outer_x1 = cur_x1;
         float outer_y1 = cur_y1;
         float outer_x2 = cur_x1 + ((cur_x2 - cur_x1) * (vals_sum / cur_sum));
         float outer_y2 = cur_y2;
         float outer_w  = outer_x2 - outer_x1;
         float outer_h  = outer_y2 - outer_y1;
         
         float y1_mem = outer_y1;
         TreeNode movingNode = leftNode;
         
         while (movingNode != rightNode.getRightNode()){
           float squareVal = movingNode.getValue();
           float valScaled = (squareVal / vals_sum);
           float yy2        = y1_mem + (valScaled * outer_h);
           
           movingNode.setX1(outer_x1);
           movingNode.setY1(y1_mem);
           movingNode.setX2(outer_x2);
           movingNode.setY2(yy2);
           
           y1_mem = yy2;
           movingNode = movingNode.getRightNode();
         }
         
         cur_sum -= vals_sum;
         cur_x1   = outer_x2;
         cur_w    = cur_x2 - cur_x1;
         
         firstNode2Process = movingNode;
      }
    }
  }
    
  private void divideTree2Squares(TreeNode tree){
      if (tree == null){
        return;
      }
     
      else{
        TreeNode pNode = tree.getParentNode();
        divideList2Squares(tree, pNode.getValue(), pNode.getX1(), pNode.getY1(), pNode.getX2(), pNode.getY2());
        TreeNode movingNode = tree;
        while (movingNode != null){
          divideTree2Squares(movingNode.getChildNode());
          movingNode = movingNode.getRightNode();
        }
      }
  }
         
            
  private TreeNode insertNode(int id){
    float leafVal = isLeaf(id);
    boolean isLeafBool = (leafVal < 0) ? false : true; 
    TreeNode node = findNode(id, isLeafBool);
    if (node == null){
      node = new TreeNode(id, leafVal);
      if (isLeafBool){
        leafNodes[leafNodeSize++] = node;
      }
      else{
        nonLeafNodes[nonLeafNodeSize++] = node;
      }
    }
    return node;
  }
  
  private void connect(int parent, int child){
    TreeNode parentNode = insertNode(parent);
    TreeNode childNode  = insertNode(child);
    
    if (parentNode.getChildNode() == null){
      parentNode.setChildNode(childNode);
      childNode.setParentNode(parentNode);
    }
    
    else{
      parentNode.getChildNode().setLeftNode(childNode);
      childNode.setRightNode(parentNode.getChildNode());
      parentNode.setChildNode(childNode);
      childNode.setParentNode(parentNode);
    }      
  }
  
    public TreeNode findSquare(float x, float y){
    for(int i = 0; i < leafCnt; i++){
      float x1 = leafNodes[i].getX1();
      float y1 = leafNodes[i].getY1();
      float x2 = leafNodes[i].getX2();
      float y2 = leafNodes[i].getY2();
      
      if ((x >= x1) && (x <= x2) && (y >= y1) && (y <= y2)){
        return leafNodes[i];
      } 
      
    }
    return null;
  }

  public TreeNode[] getNonLeafNodes(){
    return nonLeafNodes;
  }
  
  private float calculateValues(TreeNode node){
    TreeNode movingNode = node.getChildNode();
    float sum = 0;
   
    if (node.getValue() > (-0.1)){
        return node.getValue();
    }
   
    else{
      while (movingNode != null){
         sum += calculateValues(movingNode);
         movingNode = movingNode.getRightNode();
      }
      node.setValue(sum);
      return sum;
    }
  }
    
  
  private float isLeaf(int id){
    for(int i = 0; i < leafCnt; i++){
      if (leafData[i].id == id){
        return leafData[i].value;
      }
    }
    return -1;
  }
  
  private TreeNode findNode(int id, boolean isLeaf){
    TreeNode returnNode = null;
    
    if (isLeaf){
      for(int i = 0; i < leafNodeSize; i++){
        if (leafNodes[i].getID() == id){
          returnNode = leafNodes[i];
          break;
        }
      }
    }
    
    else{
      for(int i = 0; i < nonLeafNodeSize; i++){
        if (nonLeafNodes[i].getID() == id){
          returnNode = nonLeafNodes[i];
          break;
        }
      }
    }
    
    return returnNode;
  }
}
      
