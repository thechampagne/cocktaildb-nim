# Copyright 2022 XXIV
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
import httpClient
import strformat
import strutils
import uri
import json

type
  Cocktail* = object
    idDrink* : string
    strDrink* : string
    strDrinkAlternate* : string
    strTags* : string
    strVideo* : string
    strCategory* : string
    strIBA* : string
    strAlcoholic* : string
    strGlass* : string
    strInstructions* : string
    strInstructionsES* : string
    strInstructionsDE* : string
    strInstructionsFR* : string
    strInstructionsIT* : string
    strDrinkThumb* : string
    strIngredient1* : string
    strIngredient2* : string
    strIngredient3* : string
    strIngredient4* : string
    strIngredient5* : string
    strIngredient6* : string
    strIngredient7* : string
    strIngredient8* : string
    strIngredient9* : string
    strIngredient10* : string
    strIngredient11* : string
    strIngredient12* : string
    strIngredient13* : string
    strIngredient14* : string
    strIngredient15* : string
    strMeasure1* : string
    strMeasure2* : string
    strMeasure3* : string
    strMeasure4* : string
    strMeasure5* : string
    strMeasure6* : string
    strMeasure7* : string
    strMeasure8* : string
    strMeasure9* : string
    strMeasure10* : string
    strMeasure11* : string
    strMeasure12* : string
    strMeasure13* : string
    strMeasure14* : string
    strMeasure15* : string
    strImageSource* : string
    strImageAttribution* : string
    strCreativeCommonsConfirmed* : string
    dateModified* : string

type
  Ingredient* = object
    idIngredient* : string
    strIngredient* : string
    strDescription* : string
    strType* : string
    strAlcohol* : string
    strABV* : string

type
  Filter* = object
    strDrink* : string
    strDrinkThumb* : string
    idDrink* : string

type
    CocktailDBException* = object of Exception

proc getRequest(endpoint: string): string =
  let client = newhttpClient()
  let response = client.request("https://thecocktaildb.com/api/json/v1/1/" & endpoint, httpMethod = HttpGet)
  return response.body

proc search*(s: string): seq[Cocktail] =
  ## Search cocktail by name
  ##
  ## * `s` cocktail name
  ##
  ## Raises CocktailDBException
  try:
    let response = getRequest(fmt"search.php?s={encodeUrl(s)}")
    if response.len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["drinks"].len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    var array: seq[Cocktail] = @[]
    for i in json["drinks"]:
      array.add(to(i, Cocktail))
    return array
  except:
    raise CocktailDBException.newException(getCurrentExceptionMsg())

proc searchByLetter*(c: char): seq[Cocktail] =
  ## Search cocktails by first letter
  ##
  ## * `c` cocktails letter
  ##
  ## Raises CocktailDBException
  try:
    let response = getRequest(fmt"search.php?f={c}")
    if response.len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["drinks"].len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    var array: seq[Cocktail] = @[]
    for i in json["drinks"]:
      array.add(to(i, Cocktail))
    return array
  except:
    raise CocktailDBException.newException(getCurrentExceptionMsg())

proc searchIngredient*(s: string): Ingredient =
  ## Search ingredient by name
  ##
  ## * `s` ingredient name
  ##
  ## Raises CocktailDBException
  try:
    let response = getRequest(fmt"search.php?i={encodeUrl(s)}")
    if response.len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["ingredients"].len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let data = to(json["ingredients"][0], Ingredient)
    return data
  except:
    raise CocktailDBException.newException(getCurrentExceptionMsg())

proc searchById*(i: int): Cocktail =
  ## Search cocktail details by id
  ##
  ## * `i` cocktail id
  ##
  ## Raises CocktailDBException
  try:
    let response = getRequest(fmt"lookup.php?i={i}")
    if response.len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["drinks"].len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let data = to(json["drinks"][0], Cocktail)
    return data
  except:
    raise CocktailDBException.newException(getCurrentExceptionMsg())

proc searchIngredientById*(i: int): Ingredient =
  ## Search ingredient by ID
  ##
  ## * `i` ingredient id
  ##
  ## Raises CocktailDBException
  try:
    let response = getRequest(fmt"lookup.php?iid={i}")
    if response.len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["ingredients"].len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let data = to(json["ingredients"][0], Ingredient)
    return data
  except:
    raise CocktailDBException.newException(getCurrentExceptionMsg())

proc random*(): Cocktail =
  ## Search a random cocktail
  ##
  ## Raises CocktailDBException
  try:
    let response = getRequest("random.php")
    if response.len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["drinks"].len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let data = to(json["drinks"][0], Cocktail)
    return data
  except:
    raise CocktailDBException.newException(getCurrentExceptionMsg())

proc filterByIngredient*(s: string): seq[Filter] =
  ## Filter by ingredient
  ##
  ## * `s` ingredient name
  ##
  ## Raises CocktailDBException
  try:
    let response = getRequest(fmt"filter.php?i={encodeUrl(s)}")
    if response.len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["drinks"].len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    var array: seq[Filter] = @[]
    for i in json["drinks"]:
      array.add(to(i, Filter))
    return array
  except:
    raise CocktailDBException.newException(getCurrentExceptionMsg())

proc filterByAlcoholic*(s: string): seq[Filter] =
  ## Filter by alcoholic
  ##
  ## * `s` alcoholic or non alcoholic
  ##
  ## Raises CocktailDBException
  try:
    let response = getRequest(fmt"filter.php?a={encodeUrl(s)}")
    if response.len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["drinks"].len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    var array: seq[Filter] = @[]
    for i in json["drinks"]:
      array.add(to(i, Filter))
    return array
  except:
    raise CocktailDBException.newException(getCurrentExceptionMsg())

proc filterByCategory*(s: string): seq[Filter] =
  ## Filter by Category
  ##
  ## * `s` category name
  ##
  ## Raises CocktailDBException
  try:
    let response = getRequest(fmt"filter.php?c={encodeUrl(s)}")
    if response.len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["drinks"].len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    var array: seq[Filter] = @[]
    for i in json["drinks"]:
      array.add(to(i, Filter))
    return array
  except:
    raise CocktailDBException.newException(getCurrentExceptionMsg())

proc filterByGlass*(s: string): seq[Filter] =
  ## Filter by Glass
  ##
  ## * `s` glass name
  ##
  ## Raises CocktailDBException
  try:
    let response = getRequest(fmt"filter.php?g={encodeUrl(s)}")
    if response.len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["drinks"].len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    var array: seq[Filter] = @[]
    for i in json["drinks"]:
      array.add(to(i, Filter))
    return array
  except:
    raise CocktailDBException.newException(getCurrentExceptionMsg())

proc categoriesFilter*(): seq[string] =
  ## List the categories filter
  ##
  ## Raises CocktailDBException
  try:
    let response = getRequest("list.php?c=list")
    if response.len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["drinks"].len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    var array: seq[string] = @[]
    for i in json["drinks"]:
      array.add(i["strCategory"].str)
    return array
  except:
    raise CocktailDBException.newException(getCurrentExceptionMsg())

proc glassesFilter*(): seq[string] =
  ## List the glasses filter
  ##
  ## Raises CocktailDBException
  try:
    let response = getRequest("list.php?g=list")
    if response.len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["drinks"].len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    var array: seq[string] = @[]
    for i in json["drinks"]:
      array.add(i["strGlass"].str)
    return array
  except:
    raise CocktailDBException.newException(getCurrentExceptionMsg())

proc ingredientsFilter*(): seq[string] =
  ## List the ingredients filter
  ##
  ## Raises CocktailDBException
  try:
    let response = getRequest("list.php?i=list")
    if response.len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["drinks"].len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    var array: seq[string] = @[]
    for i in json["drinks"]:
      array.add(i["strIngredient1"].str)
    return array
  except:
    raise CocktailDBException.newException(getCurrentExceptionMsg())

proc alcoholicFilter*(): seq[string] =
  ## List the alcoholic filter
  ##
  ## Raises CocktailDBException
  try:
    let response = getRequest("list.php?a=list")
    if response.len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["drinks"].len == 0:
      raise CocktailDBException.newException("Something went wrong: Empty response")
    var array: seq[string] = @[]
    for i in json["drinks"]:
      array.add(i["strAlcoholic"].str)
    return array
  except:
    raise CocktailDBException.newException(getCurrentExceptionMsg())
