<br>
<p align="center">
  <img src ="https://raw.githubusercontent.com/remirobert/RRTagController/master/source/banner.png"/>
</p>
</br>

<p align="center"> Allows the user to make a choice among predefined tags. It should also be the opportunity to create new ones. It can validate or canceled night if at least one choice was made.
RRTagController is a subClass of an UIViewController. It's very easy to customize.</p>

<br>
<p align="center">
  <img src ="https://raw.githubusercontent.com/remirobert/RRTagController/master/source/anim.gif"/>
</p>
</br>

<h3 align="center">Usage</h3>
only one line of code enough to use it : 
```Swift
let tag = ["Albanie", "Allemagne", "Andorre", "Autriche-Hongrie", "Belgique", "Bulgarie", "Danemark", "Espagne", "France", "Grèce", "Italie", "Liechtenstein", "Luxembourg", "Monaco", "Monténégro", "Norvège", "Pays-Bas", "Portugal", "Roumanie", "Royaume-Uni", "Russie", "Saint-Marin", "Serbie", "Suède", "Suisse"]
        
RRTagController.displayTagController(parentController: self, tagsString: tag,
blockFinish: { (selectedTags, unSelectedTags) -> () in
  // the user finished the selection and returns the separated list Selected and not selected.
  }) { () -> () in
  // here the user cancel the selection, nothing is returned.
}
```
