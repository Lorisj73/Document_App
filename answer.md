# Document réponse projet Document app

## 01 - Environnement

### Exercice 1 : 

- Les Targets : Dans Xcode, un "target" représente un produit final que vous souhaitez construire. Chaque target peut avoir sa propre configuration de construction et ses propres fichiers source. Par exemple, vous pourriez avoir un target pour votre application iOS, un autre pour une extension de widget, et un autre pour des tests unitaires. Les targets permettent de définir les paramètres spécifiques à chaque produit, comme les icônes, les versions, et les dépendances.
- Les Fichiers : Un projet Xcode est composé de nombreux fichiers, y compris le code source (comme les fichiers Swift ou Objective-C), les fichiers de ressources (comme les images ou les fichiers audio), et les fichiers de configuration (comme les fichiers plist). Ces fichiers sont organisés dans une structure de dossier qui peut être gérée dans le navigateur de projet d’Xcode.
- Les Assets : Les assets sont des ressources comme des images, des polices de caractère, ou des fichiers de son qui sont utilisées dans votre application. Xcode utilise un "Asset Catalog" pour gérer ces ressources. Cela facilite l'organisation, l'ajout, et la référence aux assets dans votre projet. Le catalog d'assets prend également en charge différentes résolutions d'écran et appareils.
- Ouvrir le Storyboard : Le storyboard dans Xcode est un outil visuel qui permet de concevoir les interfaces utilisateur de votre application. En ouvrant un storyboard, vous pouvez glisser-déposer des éléments d'interface comme des boutons, des labels, et des vues, et définir les contraintes pour la disposition. Cela simplifie le processus de conception de l'interface utilisateur et permet une visualisation interactive de l'application.
- Ouvrir un Simulateur : Xcode intègre un simulateur qui permet de tester votre application iOS sur différents appareils et versions d'iOS sans avoir besoin d'un appareil physique. Ouvrir un simulateur dans Xcode vous permet de lancer votre application dans un environnement simulé, ce qui est crucial pour tester et déboguer.
- Lancer une Application sur le Simulateur : Pour tester votre application, vous devez la lancer sur un simulateur. Cela implique de choisir un appareil simulé et une version d'iOS, puis de compiler et d'exécuter l'application. Lorsque vous - lancez l'application sur le simulateur, vous pouvez interagir avec elle comme si elle était exécutée sur un vrai appareil, ce qui vous permet de vérifier son fonctionnement et son apparence.

## Exercice 2 : 
1. ```cmd + R ``` permet d'éxecuter le code de l'application.
2.  ```cmd + shift + O ```permet d'ouvrir une barre de recherche pour aller dans un fichier rapidement. Similaire a cmd + P dans visual Studio Code.
3. Pour indenter le code, le raccourci est le suivant ``` Control + I ```
4. Pour mettre en commentaire la selection : ```CMD + /```

## Exercice 3 : 
- Pour changer de téléphone pour le simulateur, il suffit de le séléctionner en haut de la page de Xcode, sur le menu dépliant du téléphone


## 03 - Delegation

### Exercice 1 :
En programmation, l'intérêt d'une propriété statique est de rendre des valeurs fixes, c'est-à-dire qu'elles ne soient pas modifiable. Ici par exemple on rend nos données statiques car elles ne seront pas sujettes à modification

## 09 - QLPreview

### Question :
Le choix du disclosureIndicator pour les cellules d'un tableau offre plusieurs avantages en termes d'expérience utilisateur (UX) et de design d'interface. Il assure une indication claire de navigabilité, conformité aux conventions iOS, simplicité et minimalisme, favorisant ainsi le focus sur le contenu principal. 

## 10 - Importation 

### Questions :

- #selector :
En Swift, #selector est utilisé pour créer un sélecteur, un objet qui représente le nom d'une méthode. Les sélecteurs sont souvent utilisés en association avec des cibles d'actions (comme des actions de boutons) pour définir dynamiquement la méthode qui doit être appelée en réponse à un événement particulier.

- .add : Dans notre cas, le .add sert à ajouter une fonction appelée lorsque l'on appuie sur le bouton

- En Swift, les fonctions ciblées avec #selector doivent être exposées à l'Objective-C. La notation @objc est utilisée pour indiquer que la fonction peut être invoquée à partir d'Objective-C. Cela est nécessaire car les sélecteurs sont un concept Objective-C. 

- Il est possible d'ajouter plusieurs boutons à la barre de navigation en utilisant la propriété navigationItem.rightBarButtonItems ou navigationItem.leftBarButtonItems. Ces propriétés acceptent un tableau de UIBarButtonItem, permettant d'ajouter plusieurs boutons du côté droit ou gauche de la barre de navigation.
Exemple :
```swift
let button1 = UIBarButtonItem(title: "Bouton 1", style: .plain, target: self, action: #selector(bouton1Tapped))
let button2 = UIBarButtonItem(title: "Bouton 2", style: .plain, target: self, action: #selector(bouton2Tapped))

navigationItem.rightBarButtonItems = [button1, button2]
```
- Comme html/javascript, le defer sert à faire en sorte que le code mis dans le ***defer*** soit toujours éxécuté à la fin.
- Par exemple dans une fonction, la partie situé dans le defer serait éxécutée juste avant le return


