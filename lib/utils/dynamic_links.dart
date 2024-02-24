import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';


class DynamicLinksProvider{

  void initDynamicLink() async{
    final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if(instanceLink !=null){
      final Uri refLink = instanceLink.link;

    }
  }
}
