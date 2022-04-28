# TheCocktailDB API client

[![](https://img.shields.io/github/v/tag/thechampagne/cocktaildb-nim?label=version)](https://github.com/thechampagne/cocktaildb-nim/releases/latest) [![](https://img.shields.io/github/license/thechampagne/cocktaildb-nim)](https://github.com/thechampagne/cocktaildb-nim/blob/main/LICENSE)

TheCocktailDB API client for **Nim**.

### Download

```
nimble install cocktaildb
```

### Example

```nim
import cocktaildb

for cocktail in search("Vodka"):
  echo cocktail.strDrink
```

### License

This repo is released under the [Apache License 2.0](https://github.com/thechampagne/cocktaildb-nim/blob/main/LICENSE).

```
 Copyright 2022 XXIV

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
```