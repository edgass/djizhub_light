import 'package:flutter/material.dart';
import 'package:get/get.dart';
class TermsAndConditions extends StatelessWidget {
   TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body:  SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0,right: 25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset('assets/logo/devcon7.png',width: MediaQuery.of(context).size.width*0.1,),
                    const SizedBox(width: 15,),
                    Image.asset('assets/logo/logo_djizhub_line.png',width: MediaQuery.of(context).size.width*0.1,),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 25.0,bottom: 10.0),
                  child: Text("Accord avec les termes et conditions ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),textAlign: TextAlign.center,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("Djizhub est une application conçue par Devcon7, une entreprise dont le siège "
                      "est situé à Dakar Bambilor N°402, enregistrée au RCCM SN DKR 2023 A 54747. "
                      "En utilisant notre application, vous acceptez les conditions énoncées ci-dessous."
                    ,style: TextStyle(),textAlign: TextAlign.center,),
                ), const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("1. Services proposés"
                    ,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("Djizhub offre principalement deux services :"
                    ,style: TextStyle(),textAlign: TextAlign.center,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 15.0),
                  child: Text("a)  Création de Compte Épargne :"
                    ,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("Vous êtes libre de créer un compte épargne et de définir les paramètres selon vos préférences. "
                      "Cela inclut la fixation de la date d'échéance avant laquelle aucun retrait de fonds ne sera possible. "
                      "Vous pouvez également définir un objectif financier, avec ou sans contrainte d'objectif. "
                      "Djizhub vous accompagne dans la réalisation de vos objectifs en vous fournissant des outils d'analyse basés sur "
                      "l'intelligence artificielle, des suggestions de stratégies en fonction de vos habitudes de dépôt et de retrait, "
                      "ainsi que des notifications. Les retraits sont instantanés et sécurisés. Vos données personnelles sont sécurisées conformément "
                      "à notre politique de confidentialité. Veuillez noter que Djizhub n'est pas "
                      "responsable en cas d'erreur dans le numéro de téléphone fourni pour la restitution des fonds."
                    ,style: TextStyle()),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 15.0),
                  child: Text("a)  Création de Compte Tontine :"
                    ,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("Seul l'administrateur de la tontine est autorisé à effectuer des retraits. "
                      "Il fournira un code à tous les participants pour qu'ils puissent rejoindre et effectuer des dépôts. "
                      "Les dépôts sont traçables et chaque transaction est répertoriée en détail. "
                      "Les utilisateurs sont informés par notification à chaque dépôt ou retrait effectué dans le compte tontine. "
                      "Il est de la responsabilité de l'utilisateur de rejoindre une tontine en ayant pleinement confiance en l'administrateur. "
                      "Djizhub n'est pas responsable des retraits de fonds non réglementés par l'administrateur de la tontine. "
                      "Les utilisateurs sont libres de rejoindre ou de quitter une tontine. "
                      "Par mesure de sécurité, les numéros de téléphone de tous les membres seront visibles, mais uniquement pour l'administrateur."
                      ,style: TextStyle()),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("2. Sécurité de l'Application Djizhub"
                    ,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 15.0),
                  child: Text("a)  Protection des Données:"
                    ,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("Les données des utilisateurs sont sécurisées et protégées contre tout accès non autorisé. "
                      "Djizhub utilise des protocoles de sécurité avancés pour assurer la confidentialité des informations personnelles."
                      ,style: TextStyle()),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 15.0),
                  child: Text("a)  Authentification et Autorisation:"
                    ,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("Un système d'authentification robuste via Google, un leader du domaine, est en place pour vérifier l'identité des utilisateurs et "
                      "garantir l'accès sécurisé aux comptes."
                      "Les autorisations sont strictement contrôlées pour limiter les actions possibles en fonction du rôle de chaque utilisateur."
                      ,style: TextStyle()),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 15.0),
                  child: Text("a)  Chiffrement des Communications:"
                    ,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("Toutes les communications entre l'application et nos serveurs sont cryptées pour éviter toute interception de données sensibles."
                      ,style: TextStyle()),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 15.0),
                  child: Text("a)  Gestion des Accès:"
                    ,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("Les utilisateurs reçoivent des notifications en cas d'activités suspectes sur leur compte, garantissant une réactivité rapide en cas de problème."
                      ,style: TextStyle()),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("3. Droit de refus :"
                    ,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("L'entreprise Devcon7 se réserve le droit de refuser l'accès à l'application "
                      "à tout moment et sans avertissement, "
                      "à condition que l'utilisateur n'ait aucun fond sur Djizhub en ce moment."
                      ,style: TextStyle()),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("4. Droit exclusif: "
                    ,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("L'utilisateur reconnaît que l'application Djizhub est la propriété exclusive de l'entreprise Devcon7"
                      ,style: TextStyle()),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("5. Acceptation des Conditions"
                    ,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("En utilisant Djizhub, vous acceptez les présentes conditions d'utilisation. "
                      "Si vous n'acceptez pas ces conditions, veuillez ne pas utiliser l'application."
                      ,style: TextStyle()),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("5. Modifications"
                    ,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text("Devcon7 peut modifier ces termes et conditions à tout moment. "
                      "Les modifications entreront en vigueur dès leur publication sur l'application."
                      ,style: TextStyle()),
                ),

                const Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Text("En utilisant Djizhub, vous reconnaissez avoir lu, compris et accepté ces termes et conditions. "
                      "Si vous avez des questions ou des préoccupations, veuillez nous contacter à contact@djizhub.com."
                      ,style: TextStyle()),
                ),

                Image.asset('assets/logo/logo_djizhub_line.png',width: MediaQuery.of(context).size.width*0.3,),

                TextButton(onPressed: ()=>Get.back(), child: const Text("Fermer"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
