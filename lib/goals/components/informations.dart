import 'dart:math';

import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class Informations extends StatelessWidget {
   Informations({super.key});
   FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();


  @override
  Widget build(BuildContext context) {
    final rnd = new Random();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(fetchGoalsController.currentGoal.value.name ?? ""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Stack(
          children:[
            Positioned(
            right: 0,
            //  top: MediaQuery.of(context).size.height*0.5,

              child: Opacity(
                opacity: 0.1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Lottie.asset('assets/lottie/faible/faible${1 + rnd.nextInt(10 - 1)}.json',fit: BoxFit.contain),
                ),
              ),
            ),

            SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(calculerStrategie(),style: TextStyle(fontSize: 17),),
                SizedBox(height: 25,),
                ElevatedButton(onPressed: Get.back, child: Text("Ok, c'est partie"))
              ],
            ),
          ),

          ],
        ),
      ),
    );
  }
}

String obtenirMessageAleatoire(List<String> messages) {
  final random = Random();
  final index = random.nextInt(messages.length);
  return messages[index];
}

String obtenirJoursRestants(int jours) {

  if (jours <= 0) {
    return "vous avez été si patient et vous n'etes plus contraint par le temps ";
  }

  int annees = jours ~/ 365;
  int mois = (jours % 365) ~/ 30;
  int joursRestants = (jours % 365) % 30;

  List<String> elements = [];
  elements.add('il vous reste');

  if (annees > 0) {
    elements.add(annees == 1 ? '1 an ' : '$annees ans ');
  }

  if (mois > 0) {
    elements.add(mois == 1 ? '1 mois ' : '$mois mois ');
  }

  if (joursRestants > 0) {
    elements.add(joursRestants == 1 ? '1 jour ' : '$joursRestants jours ');
  }

  return elements.join(' ');
}


String calculerStrategie() {
  final int joursRestants = daysBetween(DateTime.now(),fetchGoalsController.currentGoal.value.dateOfWithdrawal ?? DateTime.now());
  int montantRestant = fetchGoalsController.currentGoal.value.goal! - fetchGoalsController.currentGoal.value.balance!;
  int nombreVersementsJour = joursRestants;
  int nombreVersementsSemaine = joursRestants ~/ 7;


  num montantRecommandeJour =joursRestants >0 ?(montantRestant / nombreVersementsJour).ceil().clamp(500, double.infinity) : 1;
  num montantRecommandeSemaine = joursRestants > 7 ? (montantRestant / nombreVersementsSemaine).ceil().clamp(500, double.infinity) : 500;

  // Ajustement du montant minimum recommandé à 500 FCFA
  montantRecommandeJour = montantRecommandeJour < 500 ? 500 : montantRecommandeJour;
  montantRecommandeSemaine = montantRecommandeSemaine < 500 ? 500 : montantRecommandeSemaine;
  var formatter = NumberFormat("#,###");
  String messageStrategie = "Salut ${authController.userName ?? FirebaseAuth.instance.currentUser!.displayName ?? ""}, ${obtenirJoursRestants(joursRestants)}pour atteindre votre objectif de ${formatter.format(fetchGoalsController.currentGoal.value.goal!)}FCFA. ";

  // Classification du compte en tranches
  String classificationCompte = "modéré";
  if (fetchGoalsController.currentGoal.value.balance! < fetchGoalsController.currentGoal.value.goal! * 0.25) {
    classificationCompte = "faible";
  } else if (fetchGoalsController.currentGoal.value.balance! < fetchGoalsController.currentGoal.value.goal! * 0.75) {
    classificationCompte = "modéré";
  } else {
    classificationCompte = "élevé";
  }

  if (fetchGoalsController.currentGoal.value.balance! >= fetchGoalsController.currentGoal.value.goal! && classificationCompte != "") {
    return "Félicitations ! Vous avez déjà atteint votre objectif. Continuez à rêver grand !";
  } else {
    messageStrategie += obtenirMessageAleatoire(classerCompte);
    messageStrategie += "$classificationCompte en termes d'objectif.  \n \n";

    // Messages personnalisés en fonction de la classification du compte
    switch (classificationCompte) {
      case "faible":
        messageStrategie += obtenirMessageAleatoire(faibleResume);
        messageStrategie += "${obtenirMessageAleatoire(messagesRappels)}\n\n";
        break;
      case "modéré":
        messageStrategie += obtenirMessageAleatoire(modereeResume);
        messageStrategie += obtenirMessageAleatoire(modereApresResume);
        messageStrategie += "${obtenirMessageAleatoire(messagesRappels)}\n\n";
        break;
      case "élevé":
        messageStrategie += obtenirMessageAleatoire(eleveResume);
        messageStrategie += obtenirMessageAleatoire(eleveApresResume);
        messageStrategie += "${obtenirMessageAleatoire(messagesRappels)}\n\n";
        break;
      default:
        break;
    }

    messageStrategie += "\nPour maximiser vos économies : \n";
    var formatter = NumberFormat("#,###");
    if (joursRestants <= 7) {

      // Si moins d'une semaine restante
      messageStrategie += "Je vous suggère d'économiser au moins ${formatter.format((montantRecommandeJour/10).floor() * 10)} F par jour. ";
      messageStrategie += "Cela vous permettra d'atteindre votre objectif à temps. ";
    } else {
      // Vérifier si le montant recommandé par jour est de 500 FCFA ou moins et si cela dépasse l'objectif total
      if (montantRecommandeJour <= 500 && (montantRecommandeJour * joursRestants) > montantRestant) {
        messageStrategie += "Je vous suggère d'économiser au moins ${formatter.format((montantRecommandeSemaine/10).floor() * 10)} F par semaine. ";

      }else if(montantRecommandeJour > 20000 && (montantRecommandeJour * joursRestants) >= montantRestant){
        messageStrategie += "Je vous suggère d'économiser au moins ${formatter.format((montantRecommandeJour/10).floor() * 10)} F par jour ou ";
        messageStrategie += "${formatter.format((montantRecommandeSemaine/10).floor() * 10)} F par semaine. ";
        messageStrategie += "Cela semble certes beaucoup mais si vous voulez, vous pouvez. ";
      }else {
        messageStrategie += "Je vous suggère d'économiser au moins ${formatter.format((montantRecommandeJour/10).floor() * 10)} F par jour ou ";
        messageStrategie += "${formatter.format((montantRecommandeSemaine/10).floor() * 10)} F par semaine. ";
      }
    }

    // Liste de messages d'encouragement pour chaque tranche de classification


    // Classification du compte en tranches

    if (fetchGoalsController.currentGoal.value.balance! < fetchGoalsController.currentGoal.value.goal! * 0.25) {
      classificationCompte = "faible";
    } else if (fetchGoalsController.currentGoal.value.balance! < fetchGoalsController.currentGoal.value.goal! * 0.75) {
      classificationCompte = "modere";
    } else {
      classificationCompte = "eleve";
    }

    String encouragementAleatoire = "";

    // Sélectionner le message d'encouragement en fonction de la classification du compte
    switch (classificationCompte) {
      case "faible":
        encouragementAleatoire = "\n\n${obtenirMessageAleatoire(messagesFaible)}";
        break;
      case "modere":
        encouragementAleatoire = "\n\n${obtenirMessageAleatoire(messagesModere)}";
        break;
      case "eleve":
        encouragementAleatoire = "\n\n${obtenirMessageAleatoire(messagesEleve)}";
        break;
      default:
        break;
    }

    // Ajoutez le message d'encouragement aléatoire à votre messageStrategie
    messageStrategie += encouragementAleatoire;


  }
  return messageStrategie;
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

List<String> classerCompte = [
  "Votre compte est actuellement classé comme un compte ",
  "Actuellement, votre compte est classé comme un compte ",
  "Votre compte a actuellement le statut d'un compte ",
  "Actuellement, votre compte est répertorié comme un compte ",
  "Votre compte est actuellement catégorisé comme un compte ",
  "Actuellement, votre compte est identifié comme un compte ",
  "Votre compte est actuellement étiqueté comme un compte ",
  "Actuellement, votre compte est classé comme un compte ",
  "Votre compte a actuellement le statut d'un compte ",
  "Actuellement, votre compte est répertorié comme un compte ",
  "Votre compte est actuellement catégorisé comme un compte ",
  "Actuellement, votre compte est identifié comme un compte ",
  "Votre compte est actuellement étiqueté comme un compte ",
  "Actuellement, votre compte est classé comme un compte ",
  "Actuellement, votre compte est répertorié comme un compte ",
  "Votre compte est actuellement catégorisé comme un compte ",
  "Actuellement, votre compte est identifié comme un compte ",
  "Votre compte est actuellement étiqueté comme un compte ",
  "Actuellement, votre compte est classé comme un compte ",
  "Votre compte a actuellement le statut d'un compte ",
  "Actuellement, votre compte est répertorié comme un compte ",
  "Votre compte est actuellement catégorisé comme un compte ",
  "Votre compte est actuellement étiqueté comme un compte ",
  "Actuellement, votre compte est classé comme un compte ",
  "Votre compte a actuellement le statut d'un compte ",
  "Actuellement, votre compte est répertorié comme un compte ",
  "Actuellement, votre compte est identifié comme un compte ",
];

List<String> messagesFaible = [
  "Chaque petit pas compte. Continue à économiser, même les petites contributions te rapprochent de ton objectif.",
  "N'oublie pas que chaque effort que tu fais pour économiser t'approche un peu plus de ton objectif financier.",
  "Rappelle-toi que même si tu n'as pas atteint ton objectif pour le moment, chaque économie t'aligne sur la bonne voie.",
  "Ne sois pas découragé(e) par l'écart actuel. Avec persévérance, tu atteindras ton objectif d'ici la date prévue.",
  "Continue à faire preuve de discipline financière. Tu verras les résultats de ton dévouement bientôt.",
  "Il est normal de faire face à des défis en cours de route. Reste concentré(e) sur ton objectif, tu peux le faire !",
  "N'oublie pas que l'important est de rester constant(e). Chaque contribution compte, même les plus petites.",
  "Rappelle-toi que l'important n'est pas la distance qu'il te reste à parcourir, mais le chemin que tu as déjà accompli.",
  "Continue à économiser, même si c'est progressif. Chaque Franc t'approche de ton objectif final.",
  "Rappelle-toi que le succès financier est un voyage, pas une destination. Continue à avancer avec détermination.",
  "Ne te compare pas aux autres, mais à ta propre progression. Chaque étape te rapproche de ta réussite financière.",
  "Continue à faire preuve de discipline financière. Chaque petit geste d'épargne contribue à bâtir un avenir financier solide.",
  "Rappelle-toi que le chemin vers l'indépendance financière est parfois lent, mais chaque pas compte.",
  "Continue à économiser avec persévérance. Ton dévouement paiera, même si les résultats ne sont pas immédiats.",
  "N'oublie pas que l'importance réside dans la constance. Chaque jour, tu te rapproches de ton objectif.",
  "Rappelle-toi que les petites économies d'aujourd'hui se transforment en grandes victoires demain.",
  "Ne te décourage pas par l'ampleur de l'objectif. Chaque contribution te rapproche de la réalisation de ton rêve financier.",
  "Continue à travailler sur ton objectif d'épargne. La persistance est la clé du succès financier à long terme.",
  "N'oublie pas que même les montants modestes que tu économises régulièrement auront un impact significatif sur le long terme.",
  "Rappelle-toi que la patience et la persévérance sont les compagnons fidèles du succès financier. Continue à avancer, tu es sur la bonne voie.",
];

List<String> messagesModere = [
  "Vous avez fait des progrès significatifs. Continuez à maintenir ce bon rythme !",
  "La persévérance est la clé du succès financier. Vous êtes sur la bonne voie !",
  "Fixez-vous des objectifs à court terme pour rester motivé. Vous pouvez les atteindre !", "Tu te rapproches chaque jour un peu plus de ton objectif. Continue sur cette lancée, tu es sur la bonne voie !",
  "Chaque pas que tu fais te rapproche davantage de la réalisation de ton objectif. Garde cette énergie positive !",
  "Rappelle-toi que chaque petit progrès compte. Tu es en train de conquérir ton objectif un jour à la fois.",
  "Ne sous-estime pas l'impact de chaque effort que tu fais. Bientôt, tu atteindras ce que tu t'es fixé.",
  "Continue sur cette voie impressionnante. Chaque avancée te rapproche de la concrétisation de ton objectif financier.",
  "N'oublie pas que chaque jour de travail acharné te place un pas plus près de ton succès financier.",
  "Chaque étape te rapproche du sommet. Continue à gravir les échelons vers ton objectif avec confiance.",
  "Rappelle-toi que la persistance est la clé. Ton engagement te guide progressivement vers la réussite financière.",
  "Continue à célébrer chaque petite victoire. Elles te rapprochent de la réalisation de tes rêves financiers.",
  "Chaque contribution que tu fais renforce ta position vers l'atteinte de ton objectif. Tu es sur la bonne voie !",
  "Rappelle-toi que chaque jour où tu travailles vers ton objectif, tu te rapproches de la victoire financière.",
  "Ne doute pas de ta capacité à atteindre ton but. Chaque action te rapproche du succès financier que tu mérites.",
  "Continue à avancer avec confiance. Bientôt, tu regarderas en arrière et verras tout le chemin que tu as parcouru.",
  "Chaque petit pas te rapproche de la ligne d'arrivée. Garde la foi en ton voyage vers la sécurité financière.",
  "Rappelle-toi que tu n'es plus loin maintenant. Ton objectif est à portée de main avec chaque effort supplémentaire.",
  "Continue à cultiver cette détermination. Bientôt, tu récolteras les fruits de ton travail acharné.",
  "Chaque jour est une opportunité de te rapprocher de ton objectif financier. Saisis-la avec détermination !",
  "Rappelle-toi que tu es sur la bonne voie. Chaque pas compte, et tu t'approches de plus en plus de ton but.",
  "Continue à te fixer des petits objectifs. Chaque réalisation te rapproche de ton objectif final.",
  "Chaque jour est une nouvelle occasion de te rapprocher de ton rêve financier. Saisis-la avec détermination et courage !",
];

List<String> messagesEleve = [
  "Impressionnant ! Vous êtes sur le point d'atteindre votre objectif. Rien ne peut vous arrêter maintenant !",
  "Continuez à planifier vos dépenses et trouvez des moyens d'augmenter vos économies. Le succès financier est à portée de main !",
  "Bref, Vous êtes sur le point d'atteindre votre objectif. Rien ne peut vous arrêter maintenant !",
  "Continuez à planifier vos dépenses et trouvez des moyens d'augmenter vos économies. Le succès financier est à portée de main !",
  "Vous savez, chaque jour est une opportunité d'améliorer votre situation financière. Vous avez le potentiel de réaliser de grandes choses.",
  "Bref, mes félicitations pour tes progrès impressionnants ! Tu es à quelques pas de la réalisation de ton objectif financier.",
  "Bravo cas même pour tes efforts constants ! Le succès est à portée de main, continue sur cette voie incroyable.",
  "Tu es si proche de ton objectif, c'est incroyable ! Continue à persévérer, tu y es presque !",
  "Je te félicite vraiment pour avoir surmonté chaque obstacle sur ton chemin financier. Tu es sur le point d'atteindre ton but !",
  "Tu sais, c'est un moment extraordinaire ! Tu es à quelques pas de concrétiser tes rêves financiers. Continue ainsi !",
  "Bravo pour les étapes que tu as franchies jusqu'à présent. La ligne d'arrivée est en vue, tu peux le faire !",
  "Bref, félicitations pour tes réalisations jusqu'à présent. La dernière étape de ton parcours financier est à portée de main !",
  "Tu sais, c'est un moment spécial, tu es tellement proche de ton objectif. Continue à persévérer, tu es sur le point de réussir !",
  "Félicitations pour tes efforts constants. Le moment où tu atteindras ton objectif financier est imminent, tiens bon !",
  "Mes félicitations pour chaque étape franchie. Le succès est à portée de main, continue à avancer avec détermination.",
  "C'est le moment de célébrer tes accomplissements ! Tu es sur le point d'atteindre ce que tu as travaillé si dur à réaliser.",
  "Vraiment, félicitations pour être si proche de la ligne d'arrivée financière. Continue à te dépasser, tu es presque là !",
  "Bravo pour avoir atteint cette étape cruciale. Le dernier tronçon de ton voyage financier est devant toi, continue à avancer !",
  "Félicitations pour chaque petit pas vers ton objectif. La réalisation complète est à quelques pas, garde cette motivation !",
  "Tu es tellement proche de la fin de ton parcours financier. Félicitations pour avoir persévéré jusqu'à présent !",
  "Bravo pour ta détermination exceptionnelle. Tu es sur le point d'atteindre la destination financière que tu mérites.",
  "Félicitations pour avoir surmonté tant d'obstacles. Le succès est maintenant à portée de main, continue à avancer avec confiance !",
  "C'est le moment de célébrer tes accomplissements extraordinaires. Tu es à quelques pas de ton objectif financier, continue à foncer !",
  "Félicitations pour tes réussites jusqu'à présent. La dernière étape de ton voyage financier est juste devant toi, continue à avancer avec courage !",
  "Bravo pour chaque effort investi. La ligne d'arrivée est à l'horizon, continue à te rapprocher de ton objectif !",
  "Chaque jour est une opportunité d'améliorer votre situation financière. Vous avez le potentiel de réaliser de grandes choses.",
];


List<String> messagesRappel = [
  "Bref, Vous êtes sur le point d'atteindre votre objectif. Rien ne peut vous arrêter maintenant !",
  "Continuez à planifier vos dépenses et trouvez des moyens d'augmenter vos économies. Le succès financier est à portée de main !",
  "Vous savez, chaque jour est une opportunité d'améliorer votre situation financière. Vous avez le potentiel de réaliser de grandes choses.",
  "Bref, mes félicitations pour tes progrès impressionnants ! Tu es à quelques pas de la réalisation de ton objectif financier.",
  "Bravo cas même pour tes efforts constants ! Le succès est à portée de main, continue sur cette voie incroyable.",
  "Tu es si proche de ton objectif, c'est incroyable ! Continue à persévérer, tu y es presque !",
  "Je te félicite vraiment pour avoir surmonté chaque obstacle sur ton chemin financier. Tu es sur le point d'atteindre ton but !",
  "Tu sais, c'est un moment extraordinaire ! Tu es à quelques pas de concrétiser tes rêves financiers. Continue ainsi !",
  "Bravo pour les étapes que tu as franchies jusqu'à présent. La ligne d'arrivée est en vue, tu peux le faire !",
  "Bref, félicitations pour tes réalisations jusqu'à présent. La dernière étape de ton parcours financier est à portée de main !",
  "Tu sais, c'est un moment spécial, tu es tellement proche de ton objectif. Continue à persévérer, tu es sur le point de réussir !",
  "Félicitations pour tes efforts constants. Le moment où tu atteindras ton objectif financier est imminent, tiens bon !",
  "Mes félicitations pour chaque étape franchie. Le succès est à portée de main, continue à avancer avec détermination.",
  "C'est le moment de célébrer tes accomplissements ! Tu es sur le point d'atteindre ce que tu as travaillé si dur à réaliser.",
  "Vraiment, félicitations pour être si proche de la ligne d'arrivée financière. Continue à te dépasser, tu es presque là !",
  "Bravo pour avoir atteint cette étape cruciale. Le dernier tronçon de ton voyage financier est devant toi, continue à avancer !",
  "Félicitations pour chaque petit pas vers ton objectif. La réalisation complète est à quelques pas, garde cette motivation !",
  "Tu es tellement proche de la fin de ton parcours financier. Félicitations pour avoir persévéré jusqu'à présent !",
  "Bravo pour ta détermination exceptionnelle. Tu es sur le point d'atteindre la destination financière que tu mérites.",
  "Félicitations pour avoir surmonté tant d'obstacles. Le succès est maintenant à portée de main, continue à avancer avec confiance !",
  "C'est le moment de célébrer tes accomplissements extraordinaires. Tu es à quelques pas de ton objectif financier, continue à foncer !",
  "Félicitations pour tes réussites jusqu'à présent. La dernière étape de ton voyage financier est juste devant toi, continue à avancer avec courage !",
  "Bravo pour chaque effort investi. La ligne d'arrivée est à l'horizon, continue à te rapprocher de ton objectif !",
];

  List<String> messagesRappels = [
    "N'oublie pas que mettre de l'argent de côté te prépare un avenir financier plus stable.",
    "Rappelle-toi que l'épargne est le premier pas vers la liberté financière.",
    "N'oublie pas que chaque Franc mis de côté est un pas vers la sécurité financière.",
    "Rappelle-toi que l'argent épargné aujourd'hui peut devenir une opportunité d'investissement demain.",
    "N'oublie pas que chaque petite somme épargnée compte dans la construction de ta richesse future.",
    "Rappelle-toi que l'épargne régulière est la clé d'une croissance financière constante.",
    "N'oublie pas que l'épargne est le bouclier qui te protège des imprévus financiers.",
    "Rappelle-toi que l'argent mis de côté est une ressource précieuse pour atteindre tes objectifs financiers.",
    "N'oublie pas que l'épargne est un investissement en toi-même et en ton avenir financier.",
    "N'oublie pas que l'argent mis de côté est un catalyseur pour des investissements judicieux.",
    "Rappelle-toi que l'épargne te donne les moyens de saisir les opportunités qui se présentent.",
    "N'oublie pas que l'argent mis de côté est un investissement dans ta stabilité financière.",
    "Rappelle-toi que l'épargne discipline tes habitudes financières pour le mieux.",
    "N'oublie pas que l'épargne te permet de faire face aux imprévus sans stress financier.",
    "Rappelle-toi que chaque geste d'épargne te rapproche de la réalisation de tes projets.",
    "N'oublie pas que l'argent épargné t'offre la liberté de prendre des décisions sans contraintes financières.",
    "Rappelle-toi que l'épargne est la première étape vers la création de richesse à long terme.",
    "N'oublie pas que l'épargne est une habitude qui te guide vers la prospérité financière.",
    "Rappelle-toi que l'argent épargné te permet de surmonter les défis financiers avec facilité.",
    "N'oublie pas que l'argent mis de côté te donne le pouvoir de réaliser tes rêves financiers.",
    "Rappelle-toi que l'épargne te donne la flexibilité de choisir tes projets d'investissement.",
    "N'oublie pas que l'argent mis de côté est un fondement solide pour ta croissance financière.",
    "Rappelle-toi que chaque geste d'épargne te rapproche de la sécurité financière.",
    "N'oublie pas que l'épargne régulière est la clé d'une croissance financière durable.",
    "Rappelle-toi que l'argent mis de côté te donne la tranquillité d'esprit en cas de besoin.",
    "N'oublie pas que l'épargne est un investissement dans la tranquillité d'esprit future.",
    "Rappelle-toi que chaque Franc épargné est un pas vers la création de richesse à long terme.",
    "N'oublie pas que l'argent mis de côté est le carburant de tes aspirations financières.",
    "Rappelle-toi que l'épargne régulière te prépare à des opportunités d'investissement fructueuses.",
    "N'oublie pas que l'argent épargné te permet de naviguer à travers les tempêtes financières.",
    "Rappelle-toi que chaque geste d'épargne est un investissement dans ta stabilité financière.",
    "N'oublie pas que l'épargne te donne la flexibilité de saisir les opportunités qui se présentent.",
    "Rappelle-toi que l'argent mis de côté est un catalyseur pour des investissements judicieux.",
    "N'oublie pas que l'épargne régulière est la clé d'une croissance financière constante.",
    "Rappelle-toi que l'argent épargné t'offre une sécurité financière en cas de besoin.",
    "N'oublie pas que l'épargne te donne les moyens de réaliser tes rêves financiers.",
    "Rappelle-toi que chaque Franc épargné est un investissement dans ta stabilité financière.",
    "N'oublie pas que l'argent mis de côté est un pas vers une retraite confortable.",
    "Rappelle-toi que l'épargne est la clé pour surmonter les périodes financières difficiles.",
    "N'oublie pas que chaque geste d'épargne est un investissement dans ta stabilité financière.",
    "Rappelle-toi que l'argent épargné te donne la liberté de prendre des décisions éclairées.",
    "N'oublie pas que l'épargne régulière te prépare à des opportunités d'investissement fructueuses.",
    "Rappelle-toi que l'argent mis de côté est le fondement d'une croissance financière solide.",
    "N'oublie pas que l'épargne est la clé pour surmonter les périodes financières difficiles.",
    "Rappelle-toi que chaque Franc épargné est un investissement dans ta stabilité financière."
  ];



List<String> modereeResume = [
  "Vous avez accompli des avancées notables. Continuez sur cette lancée !",
  "Vos progrès sont remarquables. Persévérez dans ce rythme positif !",
  "Vous avez atteint des étapes importantes. Continuez à maintenir cette dynamique !",
  "Chapeau pour les progrès significatifs que vous avez réalisés. Gardez ce bon rythme !",
  "Les avancées que vous avez accomplies sont impressionnantes. Continuez ainsi !",
  "Bravo pour les progrès importants que vous avez faits. Maintenez ce bon rythme !",
  "Vous êtes sur la bonne voie avec des progrès significatifs. Continuez sur cette voie !",
  "Vos réalisations sont notables. Continuez à maintenir ce rythme positif !",
  "Vous avez réussi à faire des pas importants. Continuez sur cette voie prometteuse !",
  "Félicitations pour les progrès que vous avez faits. Continuez à avancer avec assurance !",
  "Vous avez fait des avancées remarquables. Continuez à progresser de cette manière !",
  "Continuez à maintenir ce bon rythme après des progrès significatifs réalisés !",
  "Vos succès sont évidents. Continuez à avancer avec confiance et détermination !",
  "Vous avez atteint des jalons importants. Continuez à maintenir cette dynamique positive !",
  "Chapeau pour les efforts constants et les progrès significatifs. Continuez ainsi !",
  "Vos réalisations sont dignes de reconnaissance. Continuez sur cette voie fructueuse !",
  "Continuez à maintenir ce rythme exceptionnel après avoir réalisé des progrès significatifs !",
  "Vous avez réussi à faire des progrès notables. Continuez à avancer avec détermination !",
  "Félicitations pour les avancées significatives. Continuez sur cette voie prometteuse !",
  "Continuez à maintenir ce bon rythme après avoir accompli des progrès importants !",
];

List<String> modereApresResume = [
  "N'oubliez pas de définir des objectifs à court terme pour rester motivé. Suivez votre progression régulièrement.",
  "Afin de maintenir votre motivation, pensez à établir des objectifs à court terme et suivez votre progression régulièrement.",
  "Pour rester motivé, n'oubliez pas de fixer des objectifs à court terme et suivez votre évolution de manière régulière.",
  "N'oubliez pas de définir des objectifs à court terme pour maintenir votre motivation. Assurez-vous de surveiller régulièrement votre progression.",
  "Pensez à fixer des objectifs à court terme pour maintenir votre motivation, et assurez-vous de suivre votre progression de près.",
  "Il est crucial de définir des objectifs à court terme pour rester motivé. Assurez-vous de suivre votre progression régulièrement.",
  "Afin de maintenir votre motivation, pensez à établir des objectifs à court terme et suivez votre progression de près.",
  "N'oubliez pas d'établir des objectifs à court terme pour rester motivé. Suivez votre évolution de manière régulière.",
  "Pensez à fixer des objectifs à court terme pour maintenir votre motivation, et assurez-vous de vérifier régulièrement votre progression.",
  "N'oubliez pas de définir des objectifs à court terme pour maintenir votre motivation. Suivez votre progression de près.",
  "Il est crucial de fixer des objectifs à court terme pour rester motivé. Assurez-vous de vérifier votre progression de manière régulière.",
  "Pour rester motivé, pensez à établir des objectifs à court terme et suivez votre évolution de près.",
  "N'oubliez pas de définir des objectifs à court terme pour maintenir votre motivation. Assurez-vous de surveiller régulièrement votre progression.",
  "Pensez à fixer des objectifs à court terme pour maintenir votre motivation, et assurez-vous de suivre votre progression de près.",
  "Afin de maintenir votre motivation, pensez à établir des objectifs à court terme et suivez votre progression de près.",
  "N'oubliez pas d'établir des objectifs à court terme pour rester motivé. Assurez-vous de vérifier régulièrement votre progression.",
  "Il est crucial de fixer des objectifs à court terme pour maintenir votre motivation. Suivez votre progression régulièrement.",
  "Pensez à définir des objectifs à court terme pour rester motivé. Suivez votre évolution de près.",
  "N'oubliez pas de fixer des objectifs à court terme pour maintenir votre motivation, et assurez-vous de suivre votre progression régulièrement.",
  "Afin de rester motivé, pensez à établir des objectifs à court terme et suivez votre progression de près.",
  "N'oubliez pas de définir des objectifs à court terme pour maintenir votre motivation. Assurez-vous de surveiller régulièrement votre progression.",
  "Pensez à fixer des objectifs à court terme pour maintenir votre motivation, et assurez-vous de suivre votre progression de près.",
  "Afin de maintenir votre motivation, n'oubliez pas d'établir des objectifs à court terme et suivez votre progression de manière régulière.",
  "Il est crucial de définir des objectifs à court terme pour rester motivé. Assurez-vous de suivre votre progression régulièrement.",
  "N'oubliez pas de fixer des objectifs à court terme pour maintenir votre motivation. Suivez votre progression de près.",
  "Pensez à définir des objectifs à court terme pour rester motivé, et assurez-vous de vérifier régulièrement votre progression.",
  "Afin de rester motivé, pensez à établir des objectifs à court terme et suivez votre évolution de près.",
  "N'oubliez pas de définir des objectifs à court terme pour maintenir votre motivation. Assurez-vous de surveiller régulièrement votre progression."
];

List<String> faibleResume = [
  "Vous venez de commencer votre parcours. Chaque petit effort est précieux.",
  "Vous débutez votre voyage. Chaque petit geste contribue à votre progression.",
  "Vous êtes au commencement de votre chemin. Chaque petit effort compte énormément.",
  "Votre parcours ne fait que commencer. Chaque petit pas est significatif.",
  "C'est le début de votre aventure. Chaque petit effort vous rapproche de vos objectifs.",
  "Vous êtes encore au début de votre périple. Chaque petit geste vous mène plus loin.",
  "Votre parcours débute tout juste. Chaque petit effort est une avancée.",
  "Vous en êtes aux premières étapes de votre voyage. Chaque petit pas est important.",
  "Vous commencez tout juste votre parcours. Chaque petit effort compte énormément.",
  "C'est le début de votre chemin. Chaque petit geste contribue à votre réussite.",
  "Vous êtes encore au début de votre aventure. Chaque petit effort vous rapproche de vos buts.",
  "Votre parcours est à ses débuts. Chaque petit pas est une victoire.",
  "Vous êtes aux premières pages de votre histoire. Chaque petit effort construit votre futur.",
  "C'est le début de votre périple. Chaque petit geste est une pierre vers la réussite.",
  "Votre parcours est en phase initiale. Chaque petit effort vous guide vers la réussite.",
  "Vous commencez votre aventure. Chaque petit pas est une étape vers le succès.",
  "C'est le début de votre voyage. Chaque petit geste compte pour atteindre vos objectifs.",
  "Votre parcours démarre tout juste. Chaque petit effort contribue à votre croissance.",
  "Vous êtes aux débuts de votre périple. Chaque petit pas compte pour votre réussite.",
  "C'est le commencement de votre chemin. Chaque petit geste vous rapproche de vos rêves.",
];


List<String> eleveResume = [
  "Incroyable ! Vous vous rapprochez de votre objectif. Rien ne peut vous arrêter maintenant !",
  "Formidable ! Vous êtes tout près d'atteindre votre but. Rien ne peut vous arrêter à présent !",
  "Époustouflant ! Vous êtes sur le point d'accomplir votre objectif. Rien ne peut vous arrêter désormais !",
  "Exceptionnel ! Vous atteignez bientôt votre objectif. Rien ne peut entraver votre chemin !",
  "Épatant ! Vous êtes sur le point de réaliser votre objectif. Rien ne peut vous stopper maintenant !",
  "Extraordinaire ! Vous vous rapprochez de votre objectif. Rien ne peut vous arrêter à ce stade !",
  "Stupéfiant ! Vous êtes sur le point d'atteindre votre objectif. Rien ne peut vous entraver !",
  "Phénoménal ! Vous êtes tout proche d'atteindre votre but. Rien ne peut vous arrêter maintenant !",
  "Merveilleux ! Vous êtes sur le point d'atteindre votre objectif. Rien ne peut vous arrêter à présent !",
  "Fantastique ! Vous vous rapprochez de votre objectif. Rien ne peut vous arrêter à ce stade !",
  "Impressionnant ! Vous êtes sur le point d'atteindre votre objectif. Rien ne peut vous arrêter maintenant !",
  "Incrédule ! Vous êtes tout près d'accomplir votre but. Rien ne peut vous arrêter désormais !",
  "Grandiose ! Vous atteignez bientôt votre objectif. Rien ne peut entraver votre chemin !",
  "Miraculeux ! Vous êtes sur le point de réaliser votre objectif. Rien ne peut vous stopper maintenant !",
  "Extra ! Vous êtes sur le point d'atteindre votre objectif. Rien ne peut vous entraver !",
  "Formidable ! Vous êtes tout proche d'atteindre votre but. Rien ne peut vous arrêter maintenant !",
  "Impressionnant ! Vous êtes sur le point d'atteindre votre objectif. Rien ne peut vous arrêter à présent !",
  "Exceptionnel ! Vous vous rapprochez de votre objectif. Rien ne peut vous arrêter à ce stade !",
  "Inouï ! Vous êtes sur le point d'accomplir votre but. Rien ne peut vous arrêter désormais !",
  "Remarquable ! Vous atteignez bientôt votre objectif. Rien ne peut entraver votre chemin !",
];

List<String> eleveApresResume = [
  "Continuez à planifier vos dépenses et trouvez des moyens d'augmenter vos économies. Vous êtes sur la voie du succès financier !",
  "Persévérez dans la gestion de vos dépenses et explorez des stratégies pour accroître vos économies. Le succès financier vous attend !",
  "Maintenez votre engagement à organiser vos dépenses et cherchez des opportunités pour augmenter vos économies. Vous avancez vers le succès financier !",
  "Continuez à élaborer votre budget et trouvez des moyens d'optimiser vos économies. Vous êtes sur la voie du succès financier !",
  "Poursuivez vos efforts pour planifier vos dépenses et découvrez des stratégies pour augmenter vos économies. Le succès financier vous attend !",
  "Continuez à gérer vos dépenses avec soin et cherchez des moyens d'accroître vos économies. Vous êtes sur la voie du succès financier !",
  "Persistez dans la planification de vos dépenses et trouvez des moyens d'augmenter vos économies. Le succès financier est à votre portée !",
  "Continuez à budgéter vos dépenses et explorez des stratégies pour accroître vos économies. Vous progressez vers le succès financier !",
  "Poursuivez votre démarche de planification des dépenses et cherchez des opportunités pour augmenter vos économies. Vous êtes sur la voie du succès financier !",
  "Continuez à organiser vos dépenses et trouvez des moyens d'optimiser vos économies. Le succès financier vous attend !",
  "Maintenez votre détermination à planifier vos dépenses et cherchez des moyens d'accroître vos économies. Vous avancez vers le succès financier !",
  "Continuez à gérer vos dépenses de manière réfléchie et explorez des stratégies pour augmenter vos économies. Le succès financier est à votre portée !",
  "Persistez dans la planification de vos dépenses et trouvez des moyens d'optimiser vos économies. Vous êtes sur la voie du succès financier !",
  "Continuez à budgéter vos dépenses et cherchez des opportunités pour accroître vos économies. Vous progressez vers le succès financier !",
  "Poursuivez votre démarche de planification des dépenses et explorez des stratégies pour augmenter vos économies. Le succès financier vous attend !",
  "Continuez à organiser vos dépenses et trouvez des moyens d'augmenter vos économies. Vous êtes sur la voie du succès financier !",
  "Maintenez votre détermination à planifier vos dépenses et cherchez des opportunités pour accroître vos économies. Le succès financier est à votre portée !",
  "Continuez à gérer vos dépenses de manière réfléchie et explorez des stratégies pour augmenter vos économies. Vous avancez vers le succès financier !",
  "Persistez dans la planification de vos dépenses et trouvez des moyens d'optimiser vos économies. Le succès financier vous attend !",
  "Continuez à budgéter vos dépenses et cherchez des moyens d'accroître vos économies. Vous progressez vers le succès financier !",
  "Poursuivez votre démarche de planification des dépenses et explorez des stratégies pour augmenter vos économies. Vous êtes sur la voie du succès financier !",
  "Continuez à organiser vos dépenses et trouvez des moyens d'optimiser vos économies. Le succès financier est à votre portée !",
  "Maintenez votre détermination à planifier vos dépenses et cherchez des opportunités pour accroître vos économies. Vous avancez vers le succès financier !",
  "Continuez à gérer vos dépenses de manière réfléchie et explorez des stratégies pour augmenter vos économies. Le succès financier vous attend !",
  "Persistez dans la planification de vos dépenses et trouvez des moyens d'optimiser vos économies. Vous êtes sur la voie du succès financier !",
  "Continuez à budgéter vos dépenses et cherchez des moyens d'accroître vos économies. Le succès financier est à votre portée !",
  "Poursuivez votre démarche de planification des dépenses et explorez des stratégies pour augmenter vos économies. Vous avancez vers le succès financier !",
  "Continuez à organiser vos dépenses et trouvez des moyens d'optimiser vos économies. Le succès financier vous attend !",
];

List<String> justificatif = [
  "Cela vous rapprochera de votre objectif à temps. Continuez à persévérer, chaque petit pas compte !",
  "En continuant ainsi, vous atteindrez votre objectif à temps. Persévérez, chaque petit effort est important !",
  "Votre persévérance vous conduira à atteindre votre objectif dans les délais. Chaque petit pas compte !",
  "En maintenant cet effort, vous réaliserez votre objectif à temps. Continuez, chaque petit geste est significatif !",
  "Cela vous aidera à atteindre votre objectif dans les temps. Continuez à persévérer, chaque petit pas compte !",
  "En poursuivant vos efforts, vous parviendrez à votre objectif à temps. Persévérez, chaque petit effort est précieux !",
  "Cela vous propulsera vers votre objectif dans les délais. Continuez à persévérer, chaque petit pas compte !",
  "Avec cette persévérance, vous atteindrez votre objectif à temps. Continuez, chaque petit geste est important !",
  "Cela vous guidera vers la réalisation de votre objectif dans les temps. Persévérez, chaque petit pas compte !",
  "En restant constant, vous réussirez à atteindre votre objectif à temps. Continuez, chaque petit effort est significatif !",
  "Cela vous permettra d'arriver à votre objectif à temps. Continuez à persévérer, chaque petit pas compte !",
  "En continuant ainsi, vous atteindrez votre objectif à temps. Persévérez, chaque petit effort est important !",
  "Votre persévérance vous conduira à atteindre votre objectif dans les délais. Chaque petit pas compte !",
  "En maintenant cet effort, vous réaliserez votre objectif à temps. Continuez, chaque petit geste est significatif !",
  "Cela vous aidera à atteindre votre objectif dans les temps. Continuez à persévérer, chaque petit pas compte !",
  "En poursuivant vos efforts, vous parviendrez à votre objectif à temps. Persévérez, chaque petit effort est précieux !",
  "Cela vous propulsera vers votre objectif dans les délais. Continuez à persévérer, chaque petit pas compte !",
  "Avec cette persévérance, vous atteindrez votre objectif à temps. Continuez, chaque petit geste est important !",
  "Cela vous guidera vers la réalisation de votre objectif dans les temps. Persévérez, chaque petit pas compte !",
  "En restant constant, vous réussirez à atteindre votre objectif à temps. Continuez, chaque petit effort est significatif !",
];