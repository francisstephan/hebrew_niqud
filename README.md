# Hebrew_niqud

## Obtenir du texte hébreu à partir d'un clavier français

Inclut les daguesh ainsi que toutes les voyelles et quelques autre signes (athna, silluq, maqqef)

## Utilisation

Référez vous à la table de correspondance pour obtenir les caractères désirés. Quelques caractères sont à mémoriser: S pour tsade, A pou ain, $ pour shin.

Après peu de temps ce processus sera naturel et vous n'aurez plus besoin de consulter la table

Voir : http://www.eludev.fr/niqud (fonctionne sur Firefox, Chrome, Safari ...)

## Quelques informations:

### Daguesh
Pour obtenir un daguesh (ou un mappiq avec h) taper . après la consonne. S'il y a aussi des voyelles, elles doivent intervenir après le point.

### Formes finales spéciales
Pour les 5 consonnes à forme finale spéciale (k,m,n,p,S), la forme finale est détectée automatiquement, à condition qu'il n'y ait aucun signe (sauf espace ou pasokh) après la consonne. Au cas contraire, spécifier la forme finale en ajoutant _ avant la consonne (_k, _p, ...)

### Accents
Deux accents sont inclus: athna (milieu de verset) et silluq (fin de verset). Les caractères correspondants "," et ";" doivent être placés après les voyelles de la consonne de tête de la syllabe portant l'accent.

## Développement

Développé avec elm - pour moi, le meilleur logiciel de développement pour application web locale - pas le plus facile à apprendre, mais le plus puissant, le plus propre et le plus efficace en termes de code généré - conclusion après avoir essayé clojurescript, scalajs, reasonml et rust.

## License

MIT

