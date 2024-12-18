<?xml version="1.0" encoding="UTF-8"?>
<!-- generated with COPASI 4.44 (Build 295) (http://www.copasi.org) at 2024-11-21T18:05:39Z -->
<?oxygen RNGSchema="http://www.copasi.org/static/schema/CopasiML.rng" type="xml"?>
<COPASI xmlns="http://www.copasi.org/static/schema" versionMajor="4" versionMinor="44" versionDevel="295" copasiSourcesModified="0">
  <ListOfFunctions>
    <Function key="Function_6" name="Constant flux (irreversible)" type="PreDefined" reversible="false">
      <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#Function_6">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        v
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_49" name="v" order="0" role="constant"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_13" name="Mass action (irreversible)" type="MassAction" reversible="false">
      <MiriamAnnotation>
<rdf:RDF xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
   <rdf:Description rdf:about="#Function_13">
   <CopasiMT:is rdf:resource="urn:miriam:obo.sbo:SBO:0000163" />
   </rdf:Description>
   </rdf:RDF>
      </MiriamAnnotation>
      <Comment>
        <body xmlns="http://www.w3.org/1999/xhtml">
<b>Mass action rate law for irreversible reactions</b>
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
    <Function key="Function_41" name="pH-1s-Logistic [1]" type="UserDefined" reversible="unspecified">
      <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Function_41">
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
        <ParameterDescription key="FunctionParameter_275" name="substrate1" order="0" role="substrate"/>
        <ParameterDescription key="FunctionParameter_274" name="k" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_273" name="enhancer" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_272" name="pH" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_266" name="pHlimit" order="4" role="constant"/>
      </ListOfParameterDescriptions>
    </Function>
  </ListOfFunctions>
  <Model key="Model_1" name="AntigenPresentation" simulationType="time" timeUnit="s" volumeUnit="ml" areaUnit="mm²" lengthUnit="mm" quantityUnit="mmol" type="stochastic" avogadroConstant="6.0221417899999999e+23">
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
      Del paper de LODISH PNAS
Agredo dos reacciones
FreeFe con parámetros aproximados de Fig 2 t1/2 =1.5 min
FreeTf con parámetros donde se establece que apoTf (TfaEn) no pega a pH neutro al receptor  t1/2 = 16 sec
Ojo, como Tfa está en otro compartimiento (soluble) más grande, esto afecta tramendamente a la k cinética.  Para lograr ese t1/2 subí la k a 1E5

En reacciones que involucran más de un compartimiento, por ejemplo una proteína de membrana (como receptor Tf) que une o libera algo soluble como Tf o Fe, Observo que  desaparece el Volumen en la ecuación de velocidad y entonces hay que  hay que multilicar la constante de velocidad por el Volumen del compartimiento 
donde ocurre la reacción de disociaci''on.

No sé qué pasa cuando ocurre la asociación de uno de membrana y uno soluble.  Hay que multiplicar por un volumen, pero no sé por cual
PARAMETROS DE Tf CYCLING
FREE FE
Lodish Proc. Natl Acad. Sci. USA Vol. 80, pp. 2258-2262, April 1983 Cell Biology
Upon prolonged incubation at pH 5, all of the iron was released from membrane-bound transferrin with a first-order rate constant of about 0.46 or a half-time of 1.5 min (data not shown).
Otro paper posterior da velocidades diferentes para los dos hierros
entre 5.5  y  1.4 min-1  Puedo usar el menos rápido 1.4 min-1 =1.4/60 s-1
Tuve que volver a 1.4

FREE Tfa
lodish JBC
6 pg/ml (77 nM)ferrotransferrin, the half-time for binding is about 3.0 min,
Usa el producto de 77*E-9 * ln(2)/3(half-time).  Yo voy a usar ln(2)/3 =0.23 min-1 = 0.23/60 s-1
Tuve que volver a .23

El Fe debe salir al citosol, de otro modo vuelve a PM.  La cinética la saco de Published, JBC Papers in Press, June 26, 2012, DOI 10.1074/jbc.M112.364208
6.3E-3 s-1
Lo mismo, me quedo con 0.38 que es en minutos (idem 0.0063 *60)






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
      <Compartment key="Compartment_3" name="soluble" simulationType="fixed" dimensionality="3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Compartment_3">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-02-14T14:47:23Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Compartment>
      <Compartment key="Compartment_4" name="membrane" simulationType="fixed" dimensionality="3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Compartment_4">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-02-14T14:48:15Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Compartment>
      <Compartment key="Compartment_5" name="imaginario" simulationType="fixed" dimensionality="3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Compartment_5">
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
      <Metabolite key="Metabolite_7" name="protonEn" simulationType="reactions" compartment="Compartment_3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_7">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2017-11-28T14:59:21Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_8" name="protonCy" simulationType="fixed" compartment="Compartment_3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_8">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2017-11-28T17:17:55Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_9" name="RabD" simulationType="reactions" compartment="Compartment_5" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_9">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2021-08-27T12:08:52Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_10" name="RabA" simulationType="reactions" compartment="Compartment_5" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_10">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2021-08-27T12:08:51Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_11" name="R-TfaEn" simulationType="reactions" compartment="Compartment_4" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_11">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-03-31T12:45:14Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_12" name="REn" simulationType="reactions" compartment="Compartment_4" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_12">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-03-31T12:45:04Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_13" name="TfaEn" simulationType="reactions" compartment="Compartment_3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_13">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-03-31T12:45:00Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_14" name="R-TfEn" simulationType="reactions" compartment="Compartment_4" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_14">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-03-31T12:45:17Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_15" name="FeEn" simulationType="reactions" compartment="Compartment_3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#Metabolite_15">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_16" name="FeCy" simulationType="reactions" compartment="Compartment_3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#Metabolite_16">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_17" name="TfEn" simulationType="reactions" compartment="Compartment_3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#Metabolite_17">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
    </ListOfMetabolites>
    <ListOfModelValues>
      <ModelValue key="ModelValue_10" name="pH" simulationType="assignment" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_10">
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
      <ModelValue key="ModelValue_11" name="kpH" simulationType="fixed" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_11">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2018-01-27T18:21:35Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </ModelValue>
      <ModelValue key="ModelValue_12" name="enhancer" simulationType="fixed" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_12">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2018-01-26T11:02:39Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </ModelValue>
      <ModelValue key="ModelValue_13" name="acidpH" simulationType="fixed" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_13">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2018-01-26T12:59:17Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </ModelValue>
      <ModelValue key="ModelValue_14" name="RabDpump" simulationType="assignment" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:dcterms="http://purl.org/dc/terms/"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_14">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-02-14T13:11:52Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
        <Comment>
          Kinetics as Fig 7.

Dynamic Traffic through the Recycling Compartment Couples the
Metal Transporter Nramp2 (DMT1) with the Transferrin Receptor*
Received for publication, December 4, 2002, and in revised form, April 5, 2003
Published, JBC Papers in Press, April 30, 2003, DOI 10.1074/jbc.M212374200
        </Comment>
        <Expression>
          &lt;CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabD],Reference=InitialConcentration>*0.0008*exp(-4*(&lt;CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn],Reference=Concentration>-1E-4))
        </Expression>
      </ModelValue>
      <ModelValue key="ModelValue_15" name="RabApump" simulationType="assignment" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:dcterms="http://purl.org/dc/terms/"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_15">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-02-14T13:11:52Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
        <Comment>
          Kinetics as Fig 7
Dynamic Traffic through the Recycling Compartment Couples the
Metal Transporter Nramp2 (DMT1) with the Transferrin Receptor*
Received for publication, December 4, 2002, and in revised form, April 5, 2003
Published, JBC Papers in Press, April 30, 2003, DOI 10.1074/jbc.M212374200
        </Comment>
        <Expression>
          &lt;CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabA],Reference=InitialConcentration>*0.00001*exp(-4*(&lt;CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn],Reference=Concentration>-1E-4))
        </Expression>
      </ModelValue>
      <ModelValue key="ModelValue_16" name="alkpH" simulationType="fixed" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_16">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-02-16T10:43:15Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </ModelValue>
      <ModelValue key="ModelValue_17" name="enhancerNegative" simulationType="fixed" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#ModelValue_17">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2018-01-26T11:02:39Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </ModelValue>
      <ModelValue key="ModelValue_18" name="kfreeFe" simulationType="assignment" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#ModelValue_18">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <Comment>
          El valor 1.66 sale del paper doi:10.1016/j.jmb.2009.11.023 tomando la t1/2 (25 sec) de fig 3B para release of apoTf
        </Comment>
        <Expression>
          &lt;CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Reference=InitialVolume>*1.66/60
        </Expression>
      </ModelValue>
      <ModelValue key="ModelValue_19" name="kfreeTfa" simulationType="assignment" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#ModelValue_19">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <Comment>
          El valor 2.8 del paper de Lodish (1/.36)
        </Comment>
        <Expression>
          &lt;CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Reference=InitialVolume>*2.8/60
        </Expression>
      </ModelValue>
      <ModelValue key="ModelValue_20" name="kFeTransport" simulationType="fixed" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#ModelValue_20">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <Comment>
          0.38 min-1 se obtuvo de DOI 10.1074/jbc.M112.364208. Fig 3 (6.3*1E-3 sec-1) *60
        </Comment>
      </ModelValue>
      <ModelValue key="ModelValue_21" name="kdisTf" simulationType="assignment" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#ModelValue_21">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <Expression>
          &lt;CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Reference=InitialVolume>*0.1/60
        </Expression>
      </ModelValue>
      <ModelValue key="ModelValue_22" name="kBindTf" simulationType="assignment" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#ModelValue_22">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <Expression>
          &lt;CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Reference=InitialVolume>*&lt;CN=Root,Model=AntigenPresentation,Vector=Values[kdisTf],Reference=InitialValue>/13E-9
        </Expression>
      </ModelValue>
    </ListOfModelValues>
    <ListOfReactions>
      <Reaction key="Reaction_4" name="ProtonPumpRabD" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Reaction_4">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2017-11-28T15:02:35Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfProducts>
          <Product metabolite="Metabolite_7" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_6858" name="v" value="0"/>
        </ListOfConstants>
        <KineticLaw function="Function_6" unitType="Default" scalingCompartment="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_49">
              <SourceParameter reference="ModelValue_14"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_5" name="ProtonPumpRabA" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Reaction_5">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2018-01-18T11:42:29Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfProducts>
          <Product metabolite="Metabolite_7" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_6864" name="v" value="0"/>
        </ListOfConstants>
        <KineticLaw function="Function_6" unitType="Default" scalingCompartment="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_49">
              <SourceParameter reference="ModelValue_15"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_6" name="FreeTfa" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Reaction_6">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-03-31T13:27:08Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_11" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_12" stoichiometry="1"/>
          <Product metabolite="Metabolite_13" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_6865" name="k" value="112000"/>
          <Constant key="Parameter_6862" name="enhancer" value="18"/>
          <Constant key="Parameter_6861" name="pH" value="5.85428"/>
          <Constant key="Parameter_6860" name="pHlimit" value="7.3"/>
        </ListOfConstants>
        <KineticLaw function="Function_41" unitType="Default" scalingCompartment="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_275">
              <SourceParameter reference="Metabolite_11"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_274">
              <SourceParameter reference="ModelValue_19"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_273">
              <SourceParameter reference="Parameter_6862"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_272">
              <SourceParameter reference="ModelValue_10"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_266">
              <SourceParameter reference="Parameter_6860"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_7" name="FreeFe" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Reaction_7">
    <dcterms:created>
      <rdf:Description>
        <dcterms:W3CDTF>2022-03-31T13:27:12Z</dcterms:W3CDTF>
      </rdf:Description>
    </dcterms:created>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_14" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_11" stoichiometry="1"/>
          <Product metabolite="Metabolite_15" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_6859" name="enhancer" value="-18"/>
          <Constant key="Parameter_8153" name="pHlimit" value="6.7"/>
          <Constant key="Parameter_5742" name="k" value="66400"/>
          <Constant key="Parameter_5739" name="pH" value="5.85428"/>
        </ListOfConstants>
        <KineticLaw function="Function_41" unitType="Default" scalingCompartment="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_275">
              <SourceParameter reference="Metabolite_14"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_274">
              <SourceParameter reference="ModelValue_18"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_273">
              <SourceParameter reference="Parameter_6859"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_272">
              <SourceParameter reference="ModelValue_10"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_266">
              <SourceParameter reference="Parameter_8153"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_8" name="FeTransport" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
xmlns:dcterms="http://purl.org/dc/terms/"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#Reaction_8">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_15" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_16" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_8154" name="enhancer" value="-18"/>
          <Constant key="Parameter_8155" name="pHlimit" value="6.7"/>
          <Constant key="Parameter_8151" name="pH" value="5.85428"/>
          <Constant key="Parameter_8152" name="k" value="0.38"/>
        </ListOfConstants>
        <KineticLaw function="Function_41" unitType="Default" scalingCompartment="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_275">
              <SourceParameter reference="Metabolite_15"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_274">
              <SourceParameter reference="ModelValue_20"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_273">
              <SourceParameter reference="Parameter_8154"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_272">
              <SourceParameter reference="ModelValue_10"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_266">
              <SourceParameter reference="Parameter_8155"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_9" name="ProtonLeak (forward)" reversible="false" fast="false" addNoise="false">
        <Comment>
          to fit kinetics in Fig. 7.  

Dynamic Traffic through the Recycling Compartment Couples the
Metal Transporter Nramp2 (DMT1) with the Transferrin Receptor*
Received for publication, December 4, 2002, and in revised form, April 5, 2003
Published, JBC Papers in Press, April 30, 2003, DOI 10.1074/jbc.M212374200

Notice author say
"These observations also indicate that the Nramp2 endosomes have a large “leakage” permeability toward H+."
        </Comment>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_8" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_7" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_5743" name="k1" value="0.04"/>
        </ListOfConstants>
        <KineticLaw function="Function_13" unitType="Default" scalingCompartment="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_80">
              <SourceParameter reference="Parameter_5743"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_81">
              <SourceParameter reference="Metabolite_8"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_10" name="ProtonLeak (backward)" reversible="false" fast="false" addNoise="false">
        <Comment>
          to fit kinetics in Fig. 7.  

Dynamic Traffic through the Recycling Compartment Couples the
Metal Transporter Nramp2 (DMT1) with the Transferrin Receptor*
Received for publication, December 4, 2002, and in revised form, April 5, 2003
Published, JBC Papers in Press, April 30, 2003, DOI 10.1074/jbc.M212374200

Notice author say
"These observations also indicate that the Nramp2 endosomes have a large “leakage” permeability toward H+."
        </Comment>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_7" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_8" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_5741" name="k1" value="0.04"/>
        </ListOfConstants>
        <KineticLaw function="Function_13" unitType="Default" scalingCompartment="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_80">
              <SourceParameter reference="Parameter_5741"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_81">
              <SourceParameter reference="Metabolite_7"/>
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
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn]" value="4.043121466403042e+27" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonCy]" value="2.8906280591999978e+26" type="Species" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabD]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabA]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[R-TfaEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[REn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[TfaEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[R-TfEn]" value="1.4453140296000001e+27" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[FeEn]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[FeCy]" value="2.8906280592000005e+30" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[TfEn]" value="2.8906280592000005e+30" type="Species" simulationType="reactions"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Global Quantities" type="Group">
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[pH]" value="5.8542754251193312" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[kpH]" value="0.00020000000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[enhancer]" value="6.4000000000000004" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[acidpH]" value="5.4000000000000004" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[RabDpump]" value="0" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[RabApump]" value="0" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[alkpH]" value="6.5" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[enhancerNegative]" value="-9.1999999999999993" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[kfreeFe]" value="66400" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[kfreeTfa]" value="112000" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[kFeTransport]" value="0.38" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[kdisTf]" value="4000" type="ModelValue" simulationType="assignment"/>
          <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Values[kBindTf]" value="7.3846153846153843e+17" type="ModelValue" simulationType="assignment"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Kinetic Parameters" type="Group">
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabD]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonPumpRabD],ParameterGroup=Parameters,Parameter=v" value="0" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[RabDpump],Reference=InitialValue>
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
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeTfa]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeTfa],ParameterGroup=Parameters,Parameter=k" value="112000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[kfreeTfa],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeTfa],ParameterGroup=Parameters,Parameter=enhancer" value="18" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeTfa],ParameterGroup=Parameters,Parameter=pH" value="5.8542754251193312" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeTfa],ParameterGroup=Parameters,Parameter=pHlimit" value="7.2999999999999998" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeFe]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeFe],ParameterGroup=Parameters,Parameter=enhancer" value="-18" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeFe],ParameterGroup=Parameters,Parameter=pHlimit" value="6.7000000000000002" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeFe],ParameterGroup=Parameters,Parameter=k" value="66400" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[kfreeFe],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FreeFe],ParameterGroup=Parameters,Parameter=pH" value="5.8542754251193312" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FeTransport]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FeTransport],ParameterGroup=Parameters,Parameter=enhancer" value="-18" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FeTransport],ParameterGroup=Parameters,Parameter=pHlimit" value="6.7000000000000002" type="ReactionParameter" simulationType="fixed"/>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FeTransport],ParameterGroup=Parameters,Parameter=pH" value="5.8542754251193312" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[FeTransport],ParameterGroup=Parameters,Parameter=k" value="0.38" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=AntigenPresentation,Vector=Values[kFeTransport],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak (forward)]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak (forward)],ParameterGroup=Parameters,Parameter=k1" value="0.040000000000000001" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak (backward)]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=AntigenPresentation,Vector=Reactions[ProtonLeak (backward)],ParameterGroup=Parameters,Parameter=k1" value="0.040000000000000001" type="ReactionParameter" simulationType="fixed"/>
          </ModelParameterGroup>
        </ModelParameterGroup>
      </ModelParameterSet>
      <ModelParameterSet key="ModelParameterSet_7" name="Parameter Set 2021-09-02 10:10:27">
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
      <ModelParameterSet key="ModelParameterSet_8" name="Parameter Set 2021-09-03 10:07:48">
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
      <ModelParameterSet key="ModelParameterSet_9" name="Parameter Set 2022-02-25 12:03:24">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#ModelParameterSet_9">
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
      <ModelParameterSet key="ModelParameterSet_10" name="Parameter Set 2022-02-25 16:23:42">
        <MiriamAnnotation>
<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#ModelParameterSet_10">
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
      <StateTemplateVariable objectReference="Metabolite_7"/>
      <StateTemplateVariable objectReference="Metabolite_15"/>
      <StateTemplateVariable objectReference="Metabolite_11"/>
      <StateTemplateVariable objectReference="Metabolite_16"/>
      <StateTemplateVariable objectReference="Metabolite_13"/>
      <StateTemplateVariable objectReference="Metabolite_12"/>
      <StateTemplateVariable objectReference="Metabolite_14"/>
      <StateTemplateVariable objectReference="ModelValue_10"/>
      <StateTemplateVariable objectReference="ModelValue_14"/>
      <StateTemplateVariable objectReference="ModelValue_15"/>
      <StateTemplateVariable objectReference="ModelValue_18"/>
      <StateTemplateVariable objectReference="ModelValue_19"/>
      <StateTemplateVariable objectReference="ModelValue_21"/>
      <StateTemplateVariable objectReference="ModelValue_22"/>
      <StateTemplateVariable objectReference="Metabolite_8"/>
      <StateTemplateVariable objectReference="Metabolite_17"/>
      <StateTemplateVariable objectReference="Metabolite_9"/>
      <StateTemplateVariable objectReference="Metabolite_10"/>
      <StateTemplateVariable objectReference="Compartment_3"/>
      <StateTemplateVariable objectReference="Compartment_4"/>
      <StateTemplateVariable objectReference="Compartment_5"/>
      <StateTemplateVariable objectReference="ModelValue_11"/>
      <StateTemplateVariable objectReference="ModelValue_12"/>
      <StateTemplateVariable objectReference="ModelValue_13"/>
      <StateTemplateVariable objectReference="ModelValue_16"/>
      <StateTemplateVariable objectReference="ModelValue_17"/>
      <StateTemplateVariable objectReference="ModelValue_20"/>
    </StateTemplate>
    <InitialState type="initialState">
      0 4.043121466403042e+27 0 0 2.8906280592000005e+30 0 0 1.4453140296000001e+27 5.8542754251193312 0 0 66400 112000 4000 7.3846153846153843e+17 2.8906280591999978e+26 2.8906280592000005e+30 0 0 4800000000 2400000 1 0.00020000000000000001 6.4000000000000004 5.4000000000000004 6.5 -9.1999999999999993 0.38 
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
        <Parameter name="StepNumber" type="unsignedInteger" value="6000"/>
        <Parameter name="StepSize" type="float" value="20"/>
        <Parameter name="Duration" type="float" value="120000"/>
        <Parameter name="TimeSeriesRequested" type="bool" value="0"/>
        <Parameter name="OutputStartTime" type="float" value="0"/>
        <Parameter name="Output Event" type="bool" value="0"/>
        <Parameter name="Start in Steady State" type="bool" value="0"/>
        <Parameter name="Use Values" type="bool" value="0"/>
        <Parameter name="Values" type="string" value=""/>
        <Parameter name="Continue on Simultaneous Events" type="bool" value="0"/>
      </Problem>
      <Method name="Deterministic (LSODA)" type="Deterministic(LSODA)">
        <Parameter name="Integrate Reduced Model" type="bool" value="0"/>
        <Parameter name="Relative Tolerance" type="unsignedFloat" value="9.9999999999999995e-07"/>
        <Parameter name="Absolute Tolerance" type="unsignedFloat" value="9.9999999999999998e-13"/>
        <Parameter name="Max Internal Steps" type="unsignedInteger" value="100000"/>
        <Parameter name="Max Internal Step Size" type="unsignedFloat" value="0"/>
      </Method>
    </Task>
    <Task key="Task_28" name="Scan" type="scan" scheduled="false" updateModel="false">
      <Problem>
        <Parameter name="Subtask" type="unsignedInteger" value="1"/>
        <ParameterGroup name="ScanItems">
          <ParameterGroup name="ScanItem">
            <Parameter name="Maximum" type="float" value="0.002"/>
            <Parameter name="Minimum" type="float" value="0.00029999999999999997"/>
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
      <Parameter name="x axis" type="string" value=""/>
      <Parameter name="y axis" type="string" value=""/>
      <Parameter name="z axis" type="string" value=""/>
      <Parameter name="plot engine" type="string" value="QWT"/>
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
      <Parameter name="plot engine" type="string" value="QCustomPlot"/>
      <Parameter name="x axis" type="string" value=""/>
      <Parameter name="y axis" type="string" value=""/>
      <Parameter name="z axis" type="string" value=""/>
      <ListOfPlotItems>
        <PlotItem name="[R-TfaEn]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1.2"/>
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
          <Parameter name="Line width" type="unsignedFloat" value="1.2"/>
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
          <Parameter name="Line width" type="unsignedFloat" value="1.2"/>
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
          <Parameter name="Line width" type="unsignedFloat" value="1.2"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[R-TfEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="[FeEn]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1.2"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[FeEn],Reference=Concentration"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="Values[pH]" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1.2"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Values[pH],Reference=Value"/>
          </ListOfChannels>
        </PlotItem>
      </ListOfPlotItems>
    </PlotSpecification>
    <PlotSpecification name="Particle Numbers, Volumes, and Global Quantity Values" type="Plot2D" active="1" taskTypes="">
      <Parameter name="log X" type="bool" value="0"/>
      <Parameter name="log Y" type="bool" value="0"/>
      <Parameter name="plot engine" type="string" value="QCustomPlot"/>
      <Parameter name="x axis" type="string" value=""/>
      <Parameter name="y axis" type="string" value=""/>
      <Parameter name="z axis" type="string" value=""/>
      <ListOfPlotItems>
        <PlotItem name="protonEn.ParticleNumber" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1.2"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn],Reference=ParticleNumber"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="R-TfaEn.ParticleNumber" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1.2"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[R-TfaEn],Reference=ParticleNumber"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="REn.ParticleNumber" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1.2"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[REn],Reference=ParticleNumber"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="TfaEn.ParticleNumber" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1.2"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[TfaEn],Reference=ParticleNumber"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="R-TfEn.ParticleNumber" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1.2"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[membrane],Vector=Metabolites[R-TfEn],Reference=ParticleNumber"/>
          </ListOfChannels>
        </PlotItem>
        <PlotItem name="FeEn.ParticleNumber" type="Curve2D">
          <Parameter name="Line type" type="unsignedInteger" value="0"/>
          <Parameter name="Line subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Line width" type="unsignedFloat" value="1.2"/>
          <Parameter name="Symbol subtype" type="unsignedInteger" value="0"/>
          <Parameter name="Color" type="string" value="auto"/>
          <Parameter name="Recording Activity" type="string" value="during"/>
          <ListOfChannels>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Reference=Time"/>
            <ChannelSpec cn="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[FeEn],Reference=ParticleNumber"/>
          </ListOfChannels>
        </PlotItem>
      </ListOfPlotItems>
    </PlotSpecification>
  </ListOfPlots>
  <GUI>
    <ListOfSliders>
      <Slider key="Slider_2" associatedEntityKey="Task_28" objectCN="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn],Reference=InitialConcentration" objectType="float" objectValue="0.0013987" minValue="0.0001" maxValue="0.1" tickNumber="1000" tickFactor="100" scaling="linear"/>
      <Slider key="Slider_3" associatedEntityKey="Task_29" objectCN="CN=Root,Model=AntigenPresentation,Vector=Compartments[soluble],Vector=Metabolites[protonEn],Reference=InitialConcentration" objectType="float" objectValue="0.0013987" minValue="0.0001" maxValue="0.1" tickNumber="1000" tickFactor="100" scaling="linear"/>
      <Slider key="Slider_4" associatedEntityKey="Task_29" objectCN="CN=Root,Model=AntigenPresentation,Vector=Compartments[imaginario],Vector=Metabolites[RabD],Reference=InitialConcentration" objectType="float" objectValue="0" minValue="0" maxValue="1.8" tickNumber="1000" tickFactor="100" scaling="linear"/>
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
    <UnitDefinition key="Unit_35" name="liter" symbol="l">
      <MiriamAnnotation>
<rdf:RDF
xmlns:dcterms="http://purl.org/dc/terms/"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<rdf:Description rdf:about="#Unit_34">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        0.001*m^3
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
