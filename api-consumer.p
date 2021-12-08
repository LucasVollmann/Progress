/*******************************************************************************\
| Para executar, é necessário possuir um token gerado pela API.                 |
| Basta acessar "https://advisor.climatempo.com.br/" e criar uma conta.         |
| Acessar "https://advisor.climatempo.com.br/home/#!/tokens" e criar um projeto |
\*******************************************************************************/

block-level on error undo, throw.

using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.RequestBuilder.

using Progress.Json.*.
using Progress.Json.ObjectModel.*.

def var oJsonObj   as JsonObject    no-undo.
def var oJsonArray as JsonArray     no-undo.
def var oReq       as IHttpRequest  no-undo.
def var oRes       as IHttpResponse no-undo.

def var oJsonObjRes   as Jsonobject no-undo.
def var oJsonArrayRes as JsonArray  no-undo.

def var ix      as int  no-undo.
def var c-url   as char no-undo.
def var c-token as char no-undo.

def temp-table city no-undo
    field id      as int  format "zzzzz9"
    field name    as char format "x(25)"
    field state   as char format "x(2)"
    field country as char format "x(2)"
    index id country state name.

assign c-token = "" /* Insira seu token aqui */
       c-url   = "http://apiadvisor.climatempo.com.br/api/v1/locale/city?country=BR&token=" + c-token.

oReq = RequestBuilder:Get(c-url):Request.
oRes = ClientBuilder:Build():Client:Execute(oReq).

if oRes:StatusCode = 200           and
   type-of(oRes:Entity, JsonArray) then do: 

    oJsonArrayRes = cast(oRes:Entity, JsonArray).

    do ix = 1 to oJsonArrayRes:length:
        oJsonObjRes = oJsonArrayRes:GetJsonObject(ix).
        
        create city.
        assign city.id      = oJsonObjRes:GetInteger("id")
               city.name    = oJsonObjRes:GetCharacter("name")
               city.state   = oJsonObjRes:GetCharacter("state")
               city.country = trim(oJsonObjRes:GetCharacter("country")).
    end.
end.

for each city:
    disp city.country
         city.state
         city.name.
end.
