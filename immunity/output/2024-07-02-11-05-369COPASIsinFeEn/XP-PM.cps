<?xml version="1.0" encoding="UTF-8"?>
<!-- generated with COPASI 4.43 (Build 288) (http://www.copasi.org) at 2024-06-26T18:06:40Z -->
<?oxygen RNGSchema="http://www.copasi.org/static/schema/CopasiML.rng" type="xml"?>
<COPASI xmlns="http://www.copasi.org/static/schema" versionMajor="4" versionMinor="43" versionDevel="288" copasiSourcesModified="0">
  <ListOfFunctions>
    <Function key="Function_13" name="Mass action (irreversible)" type="MassAction" reversible="false">
      <MiriamAnnotation>
<rdf:RDF xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Function_13">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2017-11-27T17:06:19Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
    <CopasiMT:is rdf:resource="urn:miriam:obo.sbo:SBO:0000041" />
  </rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Comment>
        <body xmlns="http://www.w3.org/1999/xhtml">
<b>Mass action rate law for first order irreversible reactions</b>
<p>
Reaction scheme where the products are created from the reactants and the change of a product quantity is proportional to the product of reactant activities. The reaction scheme does not include any reverse process that creates the reactants from the products. The change of a product quantity is proportional to the quantity of one reactant.
</p>
</body>
      </Comment>
      <Expression>
        k1*PRODUCT&lt;substrate_i>
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_80" name="k1" order="0" role="constant"/>
        <ParameterDescription key="FunctionParameter_81" name="substrate" order="1" role="substrate"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_42" name="pH-2sLogistic" type="UserDefined" reversible="unspecified">
      <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Function_42">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2018-01-24T16:54:18Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        substrate1 *substrate2* k /(1+EXP( - enhancer* (pH-pHlimit)))
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_282" name="substrate1" order="0" role="substrate"/>
        <ParameterDescription key="FunctionParameter_283" name="substrate2" order="1" role="substrate"/>
        <ParameterDescription key="FunctionParameter_281" name="k" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_286" name="enhancer" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_287" name="pH" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_288" name="pHlimit" order="5" role="constant"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_43" name="pH-1s-Logistic [1]" type="UserDefined" reversible="unspecified">
      <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Function_43">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2018-01-24T16:54:18Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        substrate1 * k /(1+EXP( - enhancer* (pH-pHlimit)))
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_294" name="substrate1" order="0" role="substrate"/>
        <ParameterDescription key="FunctionParameter_293" name="k" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_292" name="enhancer" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_291" name="pH" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_290" name="pHlimit" order="4" role="constant"/>
      </ListOfParameterDescriptions>
    </Function>
  </ListOfFunctions>
  <Model key="Model_1" name="AntigenPresentation" simulationType="time" timeUnit="s" volumeUnit="nm³" areaUnit="nm²" lengthUnit="nm" quantityUnit="amol" type="stochastic" avogadroConstant="6.0221417899999999e+23">
    <MiriamAnnotation>
<rdf:RDF
   xmlns:dcterms="http://purl.org/dc/terms/"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Model_1">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2017-01-18T16:23:27Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>

    </MiriamAnnotation>
    <Comment>
      Del paper de LODISH PNAS y JBC
Agredo dos reacciones
FreeFe con parámetros aproximados de Fig 2 t1/2 =1.5 min
FreeTf con parámetros donde se establece que apoTf (TfaEn) no pega a pH neutro al receptor  t1/2 = 16 sec
Ojo, como Tfa está en otro compartimiento (soluble) más grande, esto afecta tramendamente a la k cinética.  Para lograr ese t1/2 subí la k a 1E5
Incluí una reacción de disociación de Tf del receptor solo en PM.  Esto hace que se borre el gap que existía a tiempos cortos que no se observe en el original de Lodish


De paper The Journal of Experimental Medicine Volume 180 October 1994 1471-1483
obtengo kon y koff para SIINFKL (a pH 7.4 y T 25oC0
De paper Garstka et al. 10.1073/pnas.1416543112 obtengo que kon no se modifica mucho con T y que koff aumenta 5 veces (usan otro péptido y otra técnica, pero los valores no son tan distintos)
Con ello tomo a pH 7.4 y T 37 que es la que supone el paper
kon = 6E6 1/mM seg
koff = 1E-5*5 1/seg
Para ajustar que haya binding a 7.4 de acuerdo a estas ks pero no haya a pH5 uso dos logísticas

kmax/(1+EXP(-enhancer*(pH-pHlimit))

para kon uso kmax 6E6, enhancer 6.4 pHlimit 6.5
para koff uso kmax 0.02, enhancer -9.2 pHlimit 5.4

pH se controlacon RabD y RabA no con vATPase y NOX

El cerrado de MHC con péptido (forma pepMHC) o sin péptido (forma cMHC) tendrían la misma k.  Esto es como si los péptidos inespecíficos fueran 1 mM siempre y en todo compartimiento.  Para corregir esto supongo uM y hago kmax/1000 para la reacción
oMHCI -> cMHCI

Elimino vATPAse y NOX como metabolitos.  Con esto alivio las series y el programa corrió 180.000 ticks

elimino lyEnz y todas las hidrólisis.  La degradación corre por cuenta de de la clase de Lysosomal Digestion Step de Repast

import y export no dependen de pH como antes
    </Comment>
    <ListOfCompartments>
      <Compartment key="Compartment_2" name="soluble" simulationType="fixed" dimensionality="3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Compartment_2">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-02-14T14:47:23Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Compartment>
      <Compartment key="Compartment_3" name="membrane" simulationType="fixed" dimensionality="3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Compartment_3">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-02-14T14:48:15Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Compartment>
      <Compartment key="Compartment_4" name="imaginario" simulationType="fixed" dimensionality="3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Compartment_4">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-02-14T13:30:36Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Compartment>
    </ListOfCompartments>
    <ListOfMetabolites>
      <Metabolite key="Metabolite_6" name="ovaEn" simulationType="reactions" compartment="Compartment_2" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_6">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2020-08-20T16:09:16Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_7" name="exCxEn" simulationType="reactions" compartment="Compartment_3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_7">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2020-08-20T16:05:55Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_8" name="pepEn" simulationType="reactions" compartment="Compartment_2" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_8">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2020-08-20T16:07:47Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_9" name="oMHCIEn" simulationType="reactions" compartment="Compartment_3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_9">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2020-08-20T16:06:35Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_10" name="pepMHCIEn" simulationType="reactions" compartment="Compartment_3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_10">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2020-08-20T16:07:14Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_11" name="protonEn" simulationType="reactions" compartment="Compartment_2" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_11">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2017-11-28T14:59:21Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_12" name="cMHCIEn" simulationType="reactions" compartment="Compartment_3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_12">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2020-08-20T16:06:55Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_13" name="imCxEn" simulationType="reactions" compartment="Compartment_3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_13">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2020-08-20T16:11:10Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_14" name="RabD" simulationType="reactions" compartment="Compartment_4" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_14">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2021-08-27T12:08:52Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_15" name="RabA" simulationType="reactions" compartment="Compartment_4" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_15">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2021-08-27T12:08:51Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_16" name="R-TfaEn" simulationType="reactions" compartment="Compartment_3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_16">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-03-31T12:45:14Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_17" name="REn" simulationType="reactions" compartment="Compartment_3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_17">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-03-31T12:45:04Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_18" name="TfaEn" simulationType="reactions" compartment="Compartment_2" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_18">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-03-31T12:45:00Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_19" name="R-TfEn" simulationType="reactions" compartment="Compartment_3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_19">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-03-31T12:45:17Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
    </ListOfMetabolites>
    <ListOfModelValues>
      <ModelValue key="ModelValue_0" name="pH" simulationType="assignment" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_0">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2017-11-27T17:03:45Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <Expression>
          -log(&lt;CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn],Reference=Concentration>*1e-3)/log(10)
        </Expression>
      </ModelValue>
      <ModelValue key="ModelValue_1" name="kpH" simulationType="fixed" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_1">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2018-01-27T18:21:35Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </ModelValue>
      <ModelValue key="ModelValue_2" name="enhancer" simulationType="fixed" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_2">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2018-01-26T11:02:39Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </ModelValue>
      <ModelValue key="ModelValue_3" name="acidpH" simulationType="fixed" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_3">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2018-01-26T12:59:17Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </ModelValue>
      <ModelValue key="ModelValue_4" name="RabDpump" simulationType="assignment" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_4">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-02-14T13:11:52Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <Expression>
          &lt;CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabD],Reference=InitialConcentration>*0.0008
        </Expression>
      </ModelValue>
      <ModelValue key="ModelValue_5" name="RabApump" simulationType="assignment" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_5">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-02-14T13:11:52Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <Expression>
          &lt;CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabA],Reference=InitialConcentration>*1e-5
        </Expression>
      </ModelValue>
      <ModelValue key="ModelValue_6" name="alkpH" simulationType="fixed" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_6">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-02-16T10:43:15Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </ModelValue>
      <ModelValue key="ModelValue_7" name="enhancerNegative" simulationType="fixed" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_7">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2018-01-26T11:02:39Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </ModelValue>
    </ListOfModelValues>
    <ListOfReactions>
      <Reaction key="Reaction_5" name="MHCI-loading" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Reaction_5">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2017-01-18T16:30:48Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_9" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_8" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_10" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_6864" name="k" value="6e+06"/>
          <Constant key="Parameter_6862" name="pH" value="7"/>
          <Constant key="Parameter_6858" name="pHlimit" value="6.5"/>
          <Constant key="Parameter_6861" name="enhancer" value="6.4"/>
        </ListOfConstants>
        <KineticLaw function="Function_42" unitType="Default" scalingCompartment="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_282">
              <SourceParameter reference="Metabolite_9"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_283">
              <SourceParameter reference="Metabolite_8"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_281">
              <SourceParameter reference="Parameter_6864"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_286">
              <SourceParameter reference="ModelValue_2"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_287">
              <SourceParameter reference="ModelValue_0"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_288">
              <SourceParameter reference="ModelValue_6"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_6" name="MHCIopening" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Reaction_6">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2017-11-27T17:06:02Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_12" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_9" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_6865" name="k" value="6000"/>
          <Constant key="Parameter_7700" name="pH" value="7"/>
          <Constant key="Parameter_7699" name="pHlimit" value="5.4"/>
          <Constant key="Parameter_8182" name="enhancer" value="-9.2"/>
        </ListOfConstants>
        <KineticLaw function="Function_43" unitType="Default" scalingCompartment="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_294">
              <SourceParameter reference="Metabolite_12"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_293">
              <SourceParameter reference="Parameter_6865"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_292">
              <SourceParameter reference="ModelValue_7"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_291">
              <SourceParameter reference="ModelValue_0"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_290">
              <SourceParameter reference="ModelValue_3"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_7" name="MHCI-peptOpening" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Reaction_7">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2017-11-27T17:06:02Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_10" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_9" stoichiometry="1"/>
          <Product metabolite="Metabolite_8" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_7698" name="k" value="6000"/>
          <Constant key="Parameter_7696" name="pH" value="7"/>
          <Constant key="Parameter_8185" name="pHlimit" value="5.4"/>
          <Constant key="Parameter_8184" name="enhancer" value="-9.2"/>
        </ListOfConstants>
        <KineticLaw function="Function_43" unitType="Default" scalingCompartment="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_294">
              <SourceParameter reference="Metabolite_10"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_293">
              <SourceParameter reference="Parameter_7698"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_292">
              <SourceParameter reference="ModelValue_7"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_291">
              <SourceParameter reference="ModelValue_0"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_290">
              <SourceParameter reference="ModelValue_3"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_8" name="MHCIclosing" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Reaction_8">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2018-01-22T15:11:56Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_9" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_12" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_5740" name="k" value="6000"/>
          <Constant key="Parameter_8183" name="pH" value="7"/>
          <Constant key="Parameter_8181" name="pHlimit" value="6.5"/>
          <Constant key="Parameter_6534" name="enhancer" value="6.4"/>
        </ListOfConstants>
        <KineticLaw function="Function_43" unitType="Default" scalingCompartment="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_294">
              <SourceParameter reference="Metabolite_9"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_293">
              <SourceParameter reference="Parameter_5740"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_292">
              <SourceParameter reference="ModelValue_2"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_291">
              <SourceParameter reference="ModelValue_0"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_290">
              <SourceParameter reference="ModelValue_6"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_9" name="FreeTf" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:dcterms="http://purl.org/dc/terms/"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Reaction_9">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-03-31T13:27:08Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_16" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_17" stoichiometry="1"/>
          <Product metabolite="Metabolite_18" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_6532" name="k" value="100000"/>
          <Constant key="Parameter_7719" name="enhancer" value="18"/>
          <Constant key="Parameter_6535" name="pH" value="7"/>
          <Constant key="Parameter_7718" name="pHlimit" value="7.3"/>
        </ListOfConstants>
        <KineticLaw function="Function_43" unitType="Default" scalingCompartment="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_294">
              <SourceParameter reference="Metabolite_16"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_293">
              <SourceParameter reference="Parameter_6532"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_292">
              <SourceParameter reference="Parameter_7719"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_291">
              <SourceParameter reference="ModelValue_0"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_290">
              <SourceParameter reference="Parameter_7718"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_10" name="FreeFe" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:dcterms="http://purl.org/dc/terms/"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Reaction_10">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-03-31T13:27:12Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_19" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_16" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_8579" name="k" value="0.766"/>
          <Constant key="Parameter_8576" name="enhancer" value="-9"/>
          <Constant key="Parameter_6531" name="pH" value="7"/>
          <Constant key="Parameter_7697" name="pHlimit" value="5.7"/>
        </ListOfConstants>
        <KineticLaw function="Function_43" unitType="Default" scalingCompartment="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_294">
              <SourceParameter reference="Metabolite_19"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_293">
              <SourceParameter reference="Parameter_8579"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_292">
              <SourceParameter reference="Parameter_8576"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_291">
              <SourceParameter reference="ModelValue_0"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_290">
              <SourceParameter reference="Parameter_7697"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_11" name="disTf" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:dcterms="http://purl.org/dc/terms/"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Reaction_11">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-03-31T17:33:13Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_19" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_17" stoichiometry="1"/>
          <Product metabolite="Metabolite_18" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_7684" name="k1" value="200000"/>
        </ListOfConstants>
        <KineticLaw function="Function_13" unitType="Default">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_80">
              <SourceParameter reference="Parameter_7684"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_81">
              <SourceParameter reference="Metabolite_19"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
    </ListOfReactions>
    <ListOfModelParameterSets activeSet="ModelParameterSet_1">
      <ModelParameterSet key="ModelParameterSet_1" name="Initial State">
        <MiriamAnnotation>
<rdf:RDF
xmlns:dcterms="http://purl.org/dc/terms/"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#ModelParameterSet_1">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ModelParameterGroup cn="String=Initial Time" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation" value="0" type="Model" simulationType="time"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Compartment Sizes" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble]" value="4800000000" type="Compartment" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane]" value="2400000" type="Compartment" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario]" value="1" type="Compartment" simulationType="fixed"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Species Values" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[ovaEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[exCxEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[pepEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[oMHCIEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[pepMHCIEn]" value="1445314029.5999994" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn]" value="289062805919.99988" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[cMHCIEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[imCxEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabD]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabA]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[R-TfaEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[REn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[TfaEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[R-TfEn]" value="0" type="Species" simulationType="reactions"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Global Quantities" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[pH]" value="7" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[kpH]" value="0.00020000000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[enhancer]" value="6.4000000000000004" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[acidpH]" value="5.4000000000000004" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[RabDpump]" value="0" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[RabApump]" value="0" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[alkpH]" value="6.5" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[enhancerNegative]" value="-9.1999999999999993" type="ModelValue" simulationType="fixed"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Kinetic Parameters" type="Group">
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=k" value="6000000" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=pH" value="7" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=pHlimit" value="6.5" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[alkpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=enhancer" value="6.4000000000000004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancer],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=k" value="6000" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=pH" value="7" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=pHlimit" value="5.4000000000000004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[acidpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=enhancer" value="-9.1999999999999993" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancerNegative],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=k" value="6000" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=pH" value="7" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=pHlimit" value="5.4000000000000004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[acidpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=enhancer" value="-9.1999999999999993" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancerNegative],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=k" value="6000" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=pH" value="7" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=pHlimit" value="6.5" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[alkpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=enhancer" value="6.4000000000000004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancer],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeTf]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeTf],ParameterGroup=Parameters,Parameter=k" value="100000" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeTf],ParameterGroup=Parameters,Parameter=enhancer" value="18" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeTf],ParameterGroup=Parameters,Parameter=pH" value="7" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeTf],ParameterGroup=Parameters,Parameter=pHlimit" value="7.2999999999999998" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeFe]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeFe],ParameterGroup=Parameters,Parameter=k" value="0.76600000000000001" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeFe],ParameterGroup=Parameters,Parameter=enhancer" value="-9" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeFe],ParameterGroup=Parameters,Parameter=pH" value="7" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeFe],ParameterGroup=Parameters,Parameter=pHlimit" value="5.7000000000000002" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[disTf]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[disTf],ParameterGroup=Parameters,Parameter=k1" value="200000" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
        </ModelParameterGroup>
      </ModelParameterSet>
      <ModelParameterSet key="ModelParameterSet_5" name="Parameter Set 2021-09-02 10:10:27">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#ModelParameterSet_5">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ModelParameterGroup cn="String=Initial Time" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation" value="0" type="Model" simulationType="time"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Compartment Sizes" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble]" value="1000000" type="Compartment" simulationType="fixed"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Species Values" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[ovaEn]" value="6.02214179e+17" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[exCxEn]" value="6022141790000000" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[ovaCy]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[bMGEn]" value="6022141790000000" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[pepEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[oMHCIEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[pepMHCIEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn]" value="602214179000000" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonCy]" value="60221417900000.023" type="Species" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[cMHCIEn]" value="6022141790000000" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[pepCy]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[imCxEn]" value="6022141790000000" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabD]" value="1.0839855222e+18" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabA]" value="60221417900000000" type="Species" simulationType="reactions"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Global Quantities" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[pH]" value="5.9999999999999991" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[kpH]" value="0.00020000000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[enhancer]" value="3" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[acidpH]" value="-1.5" type="ModelValue" simulationType="fixed"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Kinetic Parameters" type="Group">
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[OVAout]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[OVAout],ParameterGroup=Parameters,Parameter=k1" value="2.0000000000000002e-05" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=k" value="10" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=pH" value="5.9999999999999991" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=pHlimit" value="5.7999999999999998" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=enhancer" value="3" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancer],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabD]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabD],ParameterGroup=Parameters,Parameter=k1" value="0.00080000000000000004" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak],ParameterGroup=Parameters,Parameter=k1" value="0.040000000000000001" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak],ParameterGroup=Parameters,Parameter=k2" value="0.040000000000000001" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=k" value="9.9999999999999995e-07" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=pH" value="5.9999999999999991" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=pHlimit" value="6" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=enhancer" value="-1.5" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[acidpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=k" value="9.9999999999999995e-07" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=pH" value="5.9999999999999991" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=pHlimit" value="6" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=enhancer" value="-1.5" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[acidpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabA]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabA],ParameterGroup=Parameters,Parameter=k1" value="5.0000000000000002e-05" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=k" value="0.01" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=pH" value="5.9999999999999991" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=pHlimit" value="5.7999999999999998" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=enhancer" value="3" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancer],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[pepImport]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[pepImport],ParameterGroup=Parameters,Parameter=k1" value="0.00020000000000000001" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[proteosome]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[proteosome],ParameterGroup=Parameters,Parameter=k1" value="0.0001" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
        </ModelParameterGroup>
      </ModelParameterSet>
      <ModelParameterSet key="ModelParameterSet_6" name="Parameter Set 2021-09-03 10:07:48">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#ModelParameterSet_6">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ModelParameterGroup cn="String=Initial Time" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation" value="0" type="Model" simulationType="time"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Compartment Sizes" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble]" value="1000000" type="Compartment" simulationType="fixed"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Species Values" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[ovaEn]" value="6.02214179e+17" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[exCxEn]" value="6022141790000000" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[ovaCy]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[bMGEn]" value="6022141790000000" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[pepEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[oMHCIEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[pepMHCIEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn]" value="602214179000000" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonCy]" value="60221417900000.023" type="Species" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[cMHCIEn]" value="6022141790000000" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[pepCy]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[imCxEn]" value="6022141790000000" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabD]" value="1.0839855222e+18" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabA]" value="60221417900000000" type="Species" simulationType="reactions"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Global Quantities" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[pH]" value="5.9999999999999991" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[kpH]" value="0.00020000000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[enhancer]" value="3" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[acidpH]" value="-1.5" type="ModelValue" simulationType="fixed"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Kinetic Parameters" type="Group">
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[OVAout]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[OVAout],ParameterGroup=Parameters,Parameter=k1" value="0.002" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=k" value="10" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=pH" value="5.9999999999999991" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=pHlimit" value="5.7999999999999998" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=enhancer" value="3" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancer],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabD]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabD],ParameterGroup=Parameters,Parameter=k1" value="0.00080000000000000004" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak],ParameterGroup=Parameters,Parameter=k1" value="0.040000000000000001" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak],ParameterGroup=Parameters,Parameter=k2" value="0.040000000000000001" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=k" value="9.9999999999999995e-07" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=pH" value="5.9999999999999991" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=pHlimit" value="6" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=enhancer" value="-1.5" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[acidpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=k" value="9.9999999999999995e-07" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=pH" value="5.9999999999999991" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=pHlimit" value="6" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=enhancer" value="-1.5" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[acidpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabA]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabA],ParameterGroup=Parameters,Parameter=k1" value="5.0000000000000002e-05" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=k" value="0.01" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=pH" value="5.9999999999999991" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=pHlimit" value="5.7999999999999998" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=enhancer" value="3" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancer],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[pepImport]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[pepImport],ParameterGroup=Parameters,Parameter=k1" value="0.002" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[proteosome]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[proteosome],ParameterGroup=Parameters,Parameter=k1" value="0.0001" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
        </ModelParameterGroup>
      </ModelParameterSet>
      <ModelParameterSet key="ModelParameterSet_7" name="Parameter Set 2022-02-25 12:03:24">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#ModelParameterSet_7">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ModelParameterGroup cn="String=Initial Time" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation" value="0" type="Model" simulationType="time"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Compartment Sizes" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble]" value="4800000000" type="Compartment" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane]" value="2400000" type="Compartment" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario]" value="1" type="Compartment" simulationType="fixed"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Species Values" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[ovaEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[exCxEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[ovaCy]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[bMGEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[pepEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[oMHCIEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[pepMHCIEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonCy]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[cMHCIEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[pepCy]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[imCxEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabD]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabA]" value="0" type="Species" simulationType="reactions"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Global Quantities" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[pH]" value="0" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[kpH]" value="0.00020000000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[enhancer]" value="6.4000000000000004" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[acidpH]" value="5.4000000000000004" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[RabDpump]" value="0" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[RabApump]" value="0" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[alkpH]" value="6.5" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[enhancerNegative]" value="-9.1999999999999993" type="ModelValue" simulationType="fixed"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Kinetic Parameters" type="Group">
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[OVAout]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[OVAout],ParameterGroup=Parameters,Parameter=k1" value="100000000000" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=k" value="6000000" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=pH" value="0" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=pHlimit" value="6.5" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[alkpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=enhancer" value="6.4000000000000004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancer],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabD]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabD],ParameterGroup=Parameters,Parameter=v" value="0" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[RabDpump],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak],ParameterGroup=Parameters,Parameter=k1" value="0.040000000000000001" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak],ParameterGroup=Parameters,Parameter=k2" value="0.040000000000000001" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=k" value="6000" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=pH" value="0" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=pHlimit" value="5.4000000000000004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[acidpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=enhancer" value="-9.1999999999999993" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancerNegative],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=k" value="6000" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=pH" value="0" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=pHlimit" value="5.4000000000000004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[acidpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=enhancer" value="-9.1999999999999993" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancerNegative],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabA]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabA],ParameterGroup=Parameters,Parameter=v" value="0" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[RabApump],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=k" value="6000" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=pH" value="0" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=pHlimit" value="6.5" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[alkpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=enhancer" value="6.4000000000000004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancer],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[pepImport]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[pepImport],ParameterGroup=Parameters,Parameter=k1" value="50000000000" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[proteosome]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[proteosome],ParameterGroup=Parameters,Parameter=k1" value="10" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
        </ModelParameterGroup>
      </ModelParameterSet>
      <ModelParameterSet key="ModelParameterSet_8" name="Parameter Set 2022-02-25 16:23:42">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#ModelParameterSet_8">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ModelParameterGroup cn="String=Initial Time" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation" value="0" type="Model" simulationType="time"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Compartment Sizes" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble]" value="4800000000" type="Compartment" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane]" value="2400000" type="Compartment" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario]" value="1" type="Compartment" simulationType="fixed"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Species Values" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[ovaEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[exCxEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[ovaCy]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[bMGEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[pepEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[oMHCIEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[pepMHCIEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonCy]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[cMHCIEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[pepCy]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[imCxEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabD]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabA]" value="0" type="Species" simulationType="reactions"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Global Quantities" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[pH]" value="0" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[kpH]" value="0.00020000000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[enhancer]" value="6.4000000000000004" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[acidpH]" value="5.4000000000000004" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[RabDpump]" value="0" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[RabApump]" value="0" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[alkpH]" value="6.5" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[enhancerNegative]" value="-9.1999999999999993" type="ModelValue" simulationType="fixed"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Kinetic Parameters" type="Group">
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[OVAout]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[OVAout],ParameterGroup=Parameters,Parameter=k1" value="1000000" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=k" value="6000000" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=pH" value="0" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=pHlimit" value="6.5" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[alkpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-loading],ParameterGroup=Parameters,Parameter=enhancer" value="6.4000000000000004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancer],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabD]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabD],ParameterGroup=Parameters,Parameter=v" value="0" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[RabDpump],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak],ParameterGroup=Parameters,Parameter=k1" value="0.040000000000000001" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak],ParameterGroup=Parameters,Parameter=k2" value="0.040000000000000001" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=k" value="6000" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=pH" value="0" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=pHlimit" value="5.4000000000000004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[acidpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIopening],ParameterGroup=Parameters,Parameter=enhancer" value="-9.1999999999999993" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancerNegative],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=k" value="6000" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=pH" value="0" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=pHlimit" value="5.4000000000000004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[acidpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCI-peptOpening],ParameterGroup=Parameters,Parameter=enhancer" value="-9.1999999999999993" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancerNegative],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabA]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabA],ParameterGroup=Parameters,Parameter=v" value="0" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[RabApump],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=k" value="6000" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=pH" value="0" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=pHlimit" value="6.5" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[alkpH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[MHCIclosing],ParameterGroup=Parameters,Parameter=enhancer" value="6.4000000000000004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[enhancer],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[pepImport]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[pepImport],ParameterGroup=Parameters,Parameter=k1" value="100000" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[proteosome]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[proteosome],ParameterGroup=Parameters,Parameter=k1" value="0.01" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
        </ModelParameterGroup>
      </ModelParameterSet>
    </ListOfModelParameterSets>
    <StateTemplate>
      <StateTemplateVariable objectReference="Model_1"/>
      <StateTemplateVariable objectReference="Metabolite_9"/>
      <StateTemplateVariable objectReference="Metabolite_18"/>
      <StateTemplateVariable objectReference="Metabolite_16"/>
      <StateTemplateVariable objectReference="Metabolite_10"/>
      <StateTemplateVariable objectReference="Metabolite_19"/>
      <StateTemplateVariable objectReference="Metabolite_17"/>
      <StateTemplateVariable objectReference="Metabolite_12"/>
      <StateTemplateVariable objectReference="Metabolite_8"/>
      <StateTemplateVariable objectReference="ModelValue_0"/>
      <StateTemplateVariable objectReference="ModelValue_4"/>
      <StateTemplateVariable objectReference="ModelValue_5"/>
      <StateTemplateVariable objectReference="Metabolite_6"/>
      <StateTemplateVariable objectReference="Metabolite_11"/>
      <StateTemplateVariable objectReference="Metabolite_7"/>
      <StateTemplateVariable objectReference="Metabolite_13"/>
      <StateTemplateVariable objectReference="Metabolite_14"/>
      <StateTemplateVariable objectReference="Metabolite_15"/>
      <StateTemplateVariable objectReference="Compartment_2"/>
      <StateTemplateVariable objectReference="Compartment_3"/>
      <StateTemplateVariable objectReference="Compartment_4"/>
      <StateTemplateVariable objectReference="ModelValue_1"/>
      <StateTemplateVariable objectReference="ModelValue_2"/>
      <StateTemplateVariable objectReference="ModelValue_3"/>
      <StateTemplateVariable objectReference="ModelValue_6"/>
      <StateTemplateVariable objectReference="ModelValue_7"/>
    </StateTemplate>
    <InitialState type="initialState">
      0 0 0 0 1445314029.5999994 0 0 0 0 7 0 0 0 289062805919.99988 0 0 0 0 4800000000 2400000 1 0.00020000000000000001 6.4000000000000004 5.4000000000000004 6.5 -9.1999999999999993 
    </InitialState>
  </Model>
  <ListOfTasks>
    <Task key="Task_30" name="Steady-State" type="steadyState" scheduled="false" updateModel="false">
      <Report reference="Report_21" target="" append="1" confirmOverwrite="1"/>
      <Problem>
        <Parameter name="JacobianRequested" type="bool" value="1"/>
        <Parameter name="StabilityAnalysisRequested" type="bool" value="1"/>
      </Problem>
      <Method name="Enhanced Newton" type="EnhancedNewton">
        <Parameter name="Resolution" type="unsignedFloat" value="1.0000000000000001e-09"/>
        <Parameter name="Derivation Factor" type="unsignedFloat" value="0.001"/>
        <Parameter name="Use Newton" type="bool" value="1"/>
        <Parameter name="Use Integration" type="bool" value="1"/>
        <Parameter name="Use Back Integration" type="bool" value="1"/>
        <Parameter name="Accept Negative Concentrations" type="bool" value="0"/>
        <Parameter name="Iteration Limit" type="unsignedInteger" value="50"/>
        <Parameter name="Maximum duration for forward integration" type="unsignedFloat" value="1000000000"/>
        <Parameter name="Maximum duration for backward integration" type="unsignedFloat" value="1000000"/>
        <Parameter name="Target Criterion" type="string" value="Distance and Rate"/>
      </Method>
    </Task>
    <Task key="Task_29" name="Time-Course" type="timeCourse" scheduled="false" updateModel="false">
      <Report reference="Report_21" target="" append="1" confirmOverwrite="1"/>
      <Problem>
        <Parameter name="AutomaticStepSize" type="bool" value="0"/>
        <Parameter name="StepNumber" type="unsignedInteger" value="120"/>
        <Parameter name="StepSize" type="float" value="1"/>
        <Parameter name="Duration" type="float" value="120"/>
        <Parameter name="TimeSeriesRequested" type="bool" value="0"/>
        <Parameter name="OutputStartTime" type="float" value="0"/>
        <Parameter name="Output Event" type="bool" value="0"/>
        <Parameter name="Start in Steady State" type="bool" value="0"/>
        <Parameter name="Use Values" type="bool" value="0"/>
        <Parameter name="Values" type="string" value=""/>
        <Parameter name="Continue on Simultaneous Events" type="bool" value="0"/>
      </Problem>
      <Method name="Deterministic (RADAU5)" type="Deterministic(RADAU5)">
        <Parameter name="Integrate Reduced Model" type="bool" value="0"/>
        <Parameter name="Relative Tolerance" type="unsignedFloat" value="0.0001"/>
        <Parameter name="Absolute Tolerance" type="unsignedFloat" value="9.9999999999999995e-07"/>
        <Parameter name="Max Internal Steps" type="unsignedInteger" value="1000000000"/>
        <Parameter name="Initial Step Size" type="unsignedFloat" value="0.001"/>
      </Method>
    </Task>
    <Task key="Task_28" name="Scan" type="scan" scheduled="false" updateModel="false">
      <Problem>
        <Parameter name="Subtask" type="unsignedInteger" value="1"/>
        <ParameterGroup name="ScanItems">
          <ParameterGroup name="ScanItem">
            <Parameter name="Maximum" type="float" value="0.0001"/>
            <Parameter name="Minimum" type="float" value="5.0000000000000002e-05"/>
            <Parameter name="Number of steps" type="unsignedInteger" value="20"/>
            <Parameter name="Object" type="cn" value="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn],Reference=InitialConcentration"/>
            <Parameter name="Type" type="unsignedInteger" value="1"/>
            <Parameter name="log" type="bool" value="1"/>
            <Parameter name="Use Values" type="bool" value="0"/>
            <Parameter name="Values" type="string" value=""/>
          </ParameterGroup>
        </ParameterGroup>
        <Parameter name="Subtask Output" type="string" value="subTaskDuring"/>
        <Parameter name="Adjust initial conditions" type="bool" value="0"/>
        <Parameter name="Continue on Error" type="bool" value="0"/>
      </Problem>
      <Method name="Scan Framework" type="ScanFramework">
      </Method>
    </Task>
    <Task key="Task_27" name="Elementary Flux Modes" type="fluxMode" scheduled="false" updateModel="false">
      <Report reference="Report_20" target="" append="1" confirmOverwrite="1"/>
      <Problem>
      </Problem>
      <Method name="EFM Algorithm" type="EFMAlgorithm">
      </Method>
    </Task>
    <Task key="Task_26" name="Optimization" type="optimization" scheduled="false" updateModel="false">
      <Report reference="Report_19" target="" append="1" confirmOverwrite="1"/>
      <Problem>
        <Parameter name="Subtask" type="cn" value="CN=Root,Vector=TaskList[Steady-State]"/>
        <ParameterText name="ObjectiveExpression" type="expression">
          
        </ParameterText>
        <Parameter name="Maximize" type="bool" value="0"/>
        <Parameter name="Randomize Start Values" type="bool" value="0"/>
        <Parameter name="Calculate Statistics" type="bool" value="1"/>
        <ParameterGroup name="OptimizationItemList">
        </ParameterGroup>
        <ParameterGroup name="OptimizationConstraintList">
        </ParameterGroup>
      </Problem>
      <Method name="Random Search" type="RandomSearch">
        <Parameter name="Log Verbosity" type="unsignedInteger" value="0"/>
        <Parameter name="Number of Iterations" type="unsignedInteger" value="100000"/>
        <Parameter name="Random Number Generator" type="unsignedInteger" value="1"/>
        <Parameter name="Seed" type="unsignedInteger" value="0"/>
      </Method>
    </Task>
    <Task key="Task_25" name="Parameter Estimation" type="parameterFitting" scheduled="false" updateModel="false">
      <Report reference="Report_18" target="" append="1" confirmOverwrite="1"/>
      <Problem>
        <Parameter name="Maximize" type="bool" value="0"/>
        <Parameter name="Randomize Start Values" type="bool" value="0"/>
        <Parameter name="Calculate Statistics" type="bool" value="1"/>
        <ParameterGroup name="OptimizationItemList">
        </ParameterGroup>
        <ParameterGroup name="OptimizationConstraintList">
        </ParameterGroup>
        <Parameter name="Steady-State" type="cn" value="CN=Root,Vector=TaskList[Steady-State]"/>
        <Parameter name="Time-Course" type="cn" value="CN=Root,Vector=TaskList[Time-Course]"/>
        <Parameter name="Create Parameter Sets" type="bool" value="0"/>
        <Parameter name="Use Time Sens" type="bool" value="0"/>
        <Parameter name="Time-Sens" type="cn" value=""/>
        <ParameterGroup name="Experiment Set">
        </ParameterGroup>
        <ParameterGroup name="Validation Set">
          <Parameter name="Weight" type="unsignedFloat" value="1"/>
          <Parameter name="Threshold" type="unsignedInteger" value="5"/>
        </ParameterGroup>
      </Problem>
      <Method name="Evolutionary Programming" type="EvolutionaryProgram">
        <Parameter name="Log Verbosity" type="unsignedInteger" value="0"/>
        <Parameter name="Number of Generations" type="unsignedInteger" value="200"/>
        <Parameter name="Population Size" type="unsignedInteger" value="20"/>
        <Parameter name="Random Number Generator" type="unsignedInteger" value="1"/>
        <Parameter name="Seed" type="unsignedInteger" value="0"/>
        <Parameter name="Stop after # Stalled Generations" type="unsignedInteger" value="0"/>
      </Method>
    </Task>
    <Task key="Task_24" name="Metabolic Control Analysis" type="metabolicControlAnalysis" scheduled="false" updateModel="false">
      <Report reference="Report_17" target="" append="1" confirmOverwrite="1"/>
      <Problem>
        <Parameter name="Steady-State" type="key" value="Task_30"/>
      </Problem>
      <Method name="MCA Method (Reder)" type="MCAMethod(Reder)">
        <Parameter name="Modulation Factor" type="unsignedFloat" value="1.0000000000000001e-09"/>
        <Parameter name="Use Reder" type="bool" value="1"/>
        <Parameter name="Use Smallbone" type="bool" value="1"/>
      </Method>
    </Task>
    <Task key="Task_23" name="Lyapunov Exponents" type="lyapunovExponents" scheduled="false" updateModel="false">
      <Report reference="Report_16" target="" append="1" confirmOverwrite="1"/>
      <Problem>
        <Parameter name="ExponentNumber" type="unsignedInteger" value="3"/>
        <Parameter name="DivergenceRequested" type="bool" value="1"/>
        <Parameter name="TransientTime" type="float" value="0"/>
      </Problem>
      <Method name="Wolf Method" type="WolfMethod">
        <Parameter name="Orthonormalization Interval" type="unsignedFloat" value="1"/>
        <Parameter name="Overall time" type="unsignedFloat" value="1000"/>
        <Parameter name="Relative Tolerance" type="unsignedFloat" value="9.9999999999999995e-07"/>
        <Parameter name="Absolute Tolerance" type="unsignedFloat" value="9.9999999999999998e-13"/>
        <Parameter name="Max Internal Steps" type="unsignedInteger" value="10000"/>
      </Method>
    </Task>
    <Task key="Task_22" name="Time Scale Separation Analysis" type="timeScaleSeparationAnalysis" scheduled="false" updateModel="false">
      <Report reference="Report_15" target="" append="1" confirmOverwrite="1"/>
      <Problem>
        <Parameter name="StepNumber" type="unsignedInteger" value="100"/>
        <Parameter name="StepSize" type="float" value="0.01"/>
        <Parameter name="Duration" type="float" value="1"/>
        <Parameter name="TimeSeriesRequested" type="bool" value="1"/>
        <Parameter name="OutputStartTime" type="float" value="0"/>
      </Problem>
      <Method name="ILDM (LSODA,Deuflhard)" type="TimeScaleSeparation(ILDM,Deuflhard)">
        <Parameter name="Deuflhard Tolerance" type="unsignedFloat" value="9.9999999999999995e-07"/>
      </Method>
    </Task>
    <Task key="Task_33" name="Sensitivities" type="sensitivities" scheduled="false" updateModel="false">
      <Report reference="Report_14" target="" append="1" confirmOverwrite="1"/>
      <Problem>
        <Parameter name="SubtaskType" type="unsignedInteger" value="1"/>
        <ParameterGroup name="TargetFunctions">
          <Parameter name="SingleObject" type="cn" value=""/>
          <Parameter name="ObjectListType" type="unsignedInteger" value="7"/>
        </ParameterGroup>
        <ParameterGroup name="ListOfVariables">
          <ParameterGroup name="Variables">
            <Parameter name="SingleObject" type="cn" value=""/>
            <Parameter name="ObjectListType" type="unsignedInteger" value="41"/>
          </ParameterGroup>
          <ParameterGroup name="Variables">
            <Parameter name="SingleObject" type="cn" value=""/>
            <Parameter name="ObjectListType" type="unsignedInteger" value="0"/>
          </ParameterGroup>
        </ParameterGroup>
      </Problem>
      <Method name="Sensitivities Method" type="SensitivitiesMethod">
        <Parameter name="Delta factor" type="unsignedFloat" value="0.001"/>
        <Parameter name="Delta minimum" type="unsignedFloat" value="9.9999999999999998e-13"/>
      </Method>
    </Task>
    <Task key="Task_32" name="Moieties" type="moieties" scheduled="false" updateModel="false">
      <Report reference="Report_11" target="" append="1" confirmOverwrite="1"/>
      <Problem>
      </Problem>
      <Method name="Householder Reduction" type="Householder">
      </Method>
    </Task>
    <Task key="Task_21" name="Cross Section" type="crosssection" scheduled="false" updateModel="false">
      <Problem>
        <Parameter name="AutomaticStepSize" type="bool" value="0"/>
        <Parameter name="StepNumber" type="unsignedInteger" value="100"/>
        <Parameter name="StepSize" type="float" value="0.01"/>
        <Parameter name="Duration" type="float" value="1"/>
        <Parameter name="TimeSeriesRequested" type="bool" value="1"/>
        <Parameter name="OutputStartTime" type="float" value="0"/>
        <Parameter name="Output Event" type="bool" value="0"/>
        <Parameter name="Start in Steady State" type="bool" value="0"/>
        <Parameter name="Use Values" type="bool" value="0"/>
        <Parameter name="Values" type="string" value=""/>
        <Parameter name="LimitCrossings" type="bool" value="0"/>
        <Parameter name="NumCrossingsLimit" type="unsignedInteger" value="0"/>
        <Parameter name="LimitOutTime" type="bool" value="0"/>
        <Parameter name="LimitOutCrossings" type="bool" value="0"/>
        <Parameter name="PositiveDirection" type="bool" value="1"/>
        <Parameter name="NumOutCrossingsLimit" type="unsignedInteger" value="0"/>
        <Parameter name="LimitUntilConvergence" type="bool" value="0"/>
        <Parameter name="ConvergenceTolerance" type="float" value="0"/>
        <Parameter name="Threshold" type="float" value="0"/>
        <Parameter name="DelayOutputUntilConvergence" type="bool" value="0"/>
        <Parameter name="OutputConvergenceTolerance" type="float" value="0"/>
        <ParameterText name="TriggerExpression" type="expression">
          
        </ParameterText>
        <Parameter name="SingleVariable" type="cn" value=""/>
        <Parameter name="Continue on Simultaneous Events" type="bool" value="0"/>
      </Problem>
      <Method name="Deterministic (LSODA)" type="Deterministic(LSODA)">
        <Parameter name="Integrate Reduced Model" type="bool" value="0"/>
        <Parameter name="Relative Tolerance" type="unsignedFloat" value="9.9999999999999995e-07"/>
        <Parameter name="Absolute Tolerance" type="unsignedFloat" value="9.9999999999999998e-13"/>
        <Parameter name="Max Internal Steps" type="unsignedInteger" value="10000"/>
        <Parameter name="Max Internal Step Size" type="unsignedFloat" value="0"/>
      </Method>
    </Task>
    <Task key="Task_20" name="Linear Noise Approximation" type="linearNoiseApproximation" scheduled="false" updateModel="false">
      <Report reference="Report_13" target="" append="1" confirmOverwrite="1"/>
      <Problem>
        <Parameter name="Steady-State" type="key" value="Task_30"/>
      </Problem>
      <Method name="Linear Noise Approximation" type="LinearNoiseApproximation">
      </Method>
    </Task>
    <Task key="Task_19" name="Time-Course Sensitivities" type="timeSensitivities" scheduled="false" updateModel="false">
      <Problem>
        <Parameter name="AutomaticStepSize" type="bool" value="0"/>
        <Parameter name="StepNumber" type="unsignedInteger" value="100"/>
        <Parameter name="StepSize" type="float" value="0.01"/>
        <Parameter name="Duration" type="float" value="1"/>
        <Parameter name="TimeSeriesRequested" type="bool" value="1"/>
        <Parameter name="OutputStartTime" type="float" value="0"/>
        <Parameter name="Output Event" type="bool" value="0"/>
        <Parameter name="Start in Steady State" type="bool" value="0"/>
        <Parameter name="Use Values" type="bool" value="0"/>
        <Parameter name="Values" type="string" value=""/>
        <ParameterGroup name="ListOfParameters">
        </ParameterGroup>
        <ParameterGroup name="ListOfTargets">
        </ParameterGroup>
      </Problem>
      <Method name="LSODA Sensitivities" type="Sensitivities(LSODA)">
        <Parameter name="Integrate Reduced Model" type="bool" value="0"/>
        <Parameter name="Relative Tolerance" type="unsignedFloat" value="9.9999999999999995e-07"/>
        <Parameter name="Absolute Tolerance" type="unsignedFloat" value="9.9999999999999998e-13"/>
        <Parameter name="Max Internal Steps" type="unsignedInteger" value="10000"/>
        <Parameter name="Max Internal Step Size" type="unsignedFloat" value="0"/>
      </Method>
    </Task>
  </ListOfTasks>
  <ListOfReports>
    <Report key="Report_21" name="Steady-State" taskType="steadyState" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Footer>
        <Object cn="CN=Root,Vector=TaskList[Steady-State]"/>
      </Footer>
    </Report>
    <Report key="Report_20" name="Elementary Flux Modes" taskType="fluxMode" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Footer>
        <Object cn="CN=Root,Vector=TaskList[Elementary Flux Modes],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_19" name="Optimization" taskType="optimization" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Optimization],Object=Description"/>
        <Object cn="String=\[Function Evaluations\]"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="String=\[Best Value\]"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="String=\[Best Parameters\]"/>
      </Header>
      <Body>
        <Object cn="CN=Root,Vector=TaskList[Optimization],Problem=Optimization,Reference=Function Evaluations"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="CN=Root,Vector=TaskList[Optimization],Problem=Optimization,Reference=Best Value"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="CN=Root,Vector=TaskList[Optimization],Problem=Optimization,Reference=Best Parameters"/>
      </Body>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Optimization],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_18" name="Parameter Estimation" taskType="parameterFitting" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Object=Description"/>
        <Object cn="String=\[Function Evaluations\]"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="String=\[Best Value\]"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="String=\[Best Parameters\]"/>
      </Header>
      <Body>
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Problem=Parameter Estimation,Reference=Function Evaluations"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Problem=Parameter Estimation,Reference=Best Value"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Problem=Parameter Estimation,Reference=Best Parameters"/>
      </Body>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_17" name="Metabolic Control Analysis" taskType="metabolicControlAnalysis" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Metabolic Control Analysis],Object=Description"/>
      </Header>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Metabolic Control Analysis],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_16" name="Lyapunov Exponents" taskType="lyapunovExponents" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Lyapunov Exponents],Object=Description"/>
      </Header>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Lyapunov Exponents],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_15" name="Time Scale Separation Analysis" taskType="timeScaleSeparationAnalysis" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Time Scale Separation Analysis],Object=Description"/>
      </Header>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Time Scale Separation Analysis],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_14" name="Sensitivities" taskType="sensitivities" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Sensitivities],Object=Description"/>
      </Header>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Sensitivities],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_13" name="Linear Noise Approximation" taskType="linearNoiseApproximation" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Linear Noise Approximation],Object=Description"/>
      </Header>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Linear Noise Approximation],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_12" name="Time-Course" taskType="timeCourse" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Time-Course],Object=Description"/>
      </Header>
      <Footer>
        <Object cn="CN=Root,Vector=TaskList[Time-Course],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_11" name="Moieties" taskType="moieties" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Moieties],Object=Description"/>
      </Header>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Moieties],Object=Result"/>
      </Footer>
    </Report>
  </ListOfReports>
  <ListOfPlots>
    <PlotSpecification name="plot" type="Plot2D" active="1" taskTypes="">
      <Parameter name="log X" type="bool" value="0"/>
      <Parameter name="log Y" type="bool" value="0"/>
      <ListOfPlotItems>
        <PlotItem name="[R-TfEn]|Values[pH]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="2"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=Value"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[R-TfEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[R-TfaEn]|Values[pH]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="2"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=Value"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[R-TfaEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[TfaEn]|Values[pH]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="2"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=Value"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[TfaEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
      </ListOfPlotItems>
    </PlotSpecification>
    <PlotSpecification name="Concentrations, Volumes, and Global Quantity Values" type="Plot2D" active="1" taskTypes="">
      <Parameter name="log X" type="bool" value="0"/>
      <Parameter name="log Y" type="bool" value="0"/>
      <ListOfPlotItems>
        <PlotItem name="[ovaEn]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[ovaEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[exCxEn]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[exCxEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[ovaCy]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[ovaCy],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[pepEn]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[pepEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[oMHCIEn]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[oMHCIEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[pepMHCIEn]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[pepMHCIEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[protonEn]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[protonCy]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonCy],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[cMHCIEn]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[cMHCIEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[pepCy]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[pepCy],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[imCxEn]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[imCxEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[RabD]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabD],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[RabA]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabA],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[R-TfaEn]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[R-TfaEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[REn]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[REn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[TfaEn]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[TfaEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[R-TfEn]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[R-TfEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="Values[pH]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=Value"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="Values[RabDpump]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Values[RabDpump],Reference=Value"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="Values[RabApump]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Values[RabApump],Reference=Value"/>
          </ListOfChannels>
        </PlotItem>
      </ListOfPlotItems>
    </PlotSpecification>
  </ListOfPlots>
  <GUI>
    <ListOfSliders>
      <Slider key="Slider_0" associatedEntityKey="Task_28" objectCN="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn],Reference=InitialConcentration" objectType="float" objectValue="0.0001" minValue="0.0001" maxValue="0.1" tickNumber="1000" tickFactor="100" scaling="linear"/>
      <Slider key="Slider_1" associatedEntityKey="Task_29" objectCN="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn],Reference=InitialConcentration" objectType="float" objectValue="0.0001" minValue="0.0001" maxValue="0.1" tickNumber="1000" tickFactor="100" scaling="linear"/>
      <Slider key="Slider_4" associatedEntityKey="Task_29" objectCN="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[cMHCIEn],Reference=InitialConcentration" objectType="float" objectValue="0" minValue="0" maxValue="1" tickNumber="1000" tickFactor="100" scaling="linear"/>
      <Slider key="Slider_5" associatedEntityKey="Task_29" objectCN="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[oMHCIEn],Reference=InitialConcentration" objectType="float" objectValue="0" minValue="0" maxValue="2" tickNumber="1000" tickFactor="100" scaling="linear"/>
      <Slider key="Slider_6" associatedEntityKey="Task_29" objectCN="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabD],Reference=InitialConcentration" objectType="float" objectValue="0" minValue="0" maxValue="1.8" tickNumber="1000" tickFactor="100" scaling="linear"/>
      <Slider key="Slider_8" associatedEntityKey="Task_29" objectCN="CN=Root,Model=AntigenPresentation,Vector=Reactions[disTf],ParameterGroup=Parameters,Parameter=k1,Reference=Value" objectType="float" objectValue="200000" minValue="5" maxValue="200000" tickNumber="1000" tickFactor="100" scaling="linear"/>
    </ListOfSliders>
  </GUI>
  <ListOfUnitDefinitions>
    <UnitDefinition key="Unit_1" name="meter" symbol="m">
      <MiriamAnnotation>
<rdf:RDF
xmlns:dcterms="http://purl.org/dc/terms/"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#Unit_0">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        m
      </Expression>
    </UnitDefinition>
    <UnitDefinition key="Unit_5" name="second" symbol="s">
      <MiriamAnnotation>
<rdf:RDF
xmlns:dcterms="http://purl.org/dc/terms/"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#Unit_4">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        s
      </Expression>
    </UnitDefinition>
    <UnitDefinition key="Unit_13" name="Avogadro" symbol="Avogadro">
      <MiriamAnnotation>
<rdf:RDF
xmlns:dcterms="http://purl.org/dc/terms/"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#Unit_12">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        Avogadro
      </Expression>
    </UnitDefinition>
    <UnitDefinition key="Unit_17" name="item" symbol="#">
      <MiriamAnnotation>
<rdf:RDF
xmlns:dcterms="http://purl.org/dc/terms/"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#Unit_16">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        #
      </Expression>
    </UnitDefinition>
    <UnitDefinition key="Unit_41" name="mole" symbol="mol">
      <MiriamAnnotation>
<rdf:RDF
xmlns:dcterms="http://purl.org/dc/terms/"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#Unit_40">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        Avogadro*#
      </Expression>
    </UnitDefinition>
  </ListOfUnitDefinitions>
</COPASI>
