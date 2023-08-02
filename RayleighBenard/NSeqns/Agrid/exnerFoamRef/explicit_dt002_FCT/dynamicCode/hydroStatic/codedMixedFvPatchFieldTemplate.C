/*---------------------------------------------------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     | Website:  https://openfoam.org
    \\  /    A nd           | Copyright (C) YEAR OpenFOAM Foundation
     \\/     M anipulation  |
-------------------------------------------------------------------------------
License
    This file is part of OpenFOAM.

    OpenFOAM is free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    OpenFOAM is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License
    along with OpenFOAM.  If not, see <http://www.gnu.org/licenses/>.

\*---------------------------------------------------------------------------*/

#include "codedMixedFvPatchFieldTemplate.H"
#include "addToRunTimeSelectionTable.H"
#include "fvPatchFieldMapper.H"
#include "volFields.H"
#include "surfaceFields.H"
#include "unitConversion.H"
//{{{ begin codeInclude
#line 33 "/home/hilary/OpenFOAM/hilary-10/run/RayleighBenard/NSeqns/Agrid/exnerFoamRef/explicit_dt002_FCT/0/Exnerp/boundaryField/ground"
#include "specie.H"
            #include "perfectGas.H"
            #include "hConstThermo.H"
            #include "constTransport.H"
//}}} end codeInclude


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

namespace Foam
{

// * * * * * * * * * * * * * * * Local Functions * * * * * * * * * * * * * * //

//{{{ begin localCode

//}}} end localCode


// * * * * * * * * * * * * * * * Global Functions  * * * * * * * * * * * * * //

extern "C"
{
    // dynamicCode:
    // SHA1 = bce59d96598c35361f2704fc0646503ea3f45bfa
    //
    // unique function name that can be checked if the correct library version
    // has been loaded
    void hydroStatic_bce59d96598c35361f2704fc0646503ea3f45bfa(bool load)
    {
        if (load)
        {
            // code that can be explicitly executed after loading
        }
        else
        {
            // code that can be explicitly executed before unloading
        }
    }
}

// * * * * * * * * * * * * * * Static Data Members * * * * * * * * * * * * * //

makeRemovablePatchTypeField
(
    fvPatchScalarField,
    hydroStaticMixedValueFvPatchScalarField
);


const char* const hydroStaticMixedValueFvPatchScalarField::SHA1sum =
    "bce59d96598c35361f2704fc0646503ea3f45bfa";


// * * * * * * * * * * * * * * * * Constructors  * * * * * * * * * * * * * * //

hydroStaticMixedValueFvPatchScalarField::
hydroStaticMixedValueFvPatchScalarField
(
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF
)
:
    mixedFvPatchField<scalar>(p, iF)
{
    if (false)
    {
        Info<<"construct hydroStatic sha1: bce59d96598c35361f2704fc0646503ea3f45bfa"
            " from patch/DimensionedField\n";
    }
}


hydroStaticMixedValueFvPatchScalarField::
hydroStaticMixedValueFvPatchScalarField
(
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF,
    const dictionary& dict
)
:
    mixedFvPatchField<scalar>(p, iF, dict)
{
    if (false)
    {
        Info<<"construct hydroStatic sha1: bce59d96598c35361f2704fc0646503ea3f45bfa"
            " from patch/dictionary\n";
    }
}


hydroStaticMixedValueFvPatchScalarField::
hydroStaticMixedValueFvPatchScalarField
(
    const hydroStaticMixedValueFvPatchScalarField& ptf,
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF,
    const fvPatchFieldMapper& mapper
)
:
    mixedFvPatchField<scalar>(ptf, p, iF, mapper)
{
    if (false)
    {
        Info<<"construct hydroStatic sha1: bce59d96598c35361f2704fc0646503ea3f45bfa"
            " from patch/DimensionedField/mapper\n";
    }
}


hydroStaticMixedValueFvPatchScalarField::
hydroStaticMixedValueFvPatchScalarField
(
    const hydroStaticMixedValueFvPatchScalarField& ptf,
    const DimensionedField<scalar, volMesh>& iF
)
:
    mixedFvPatchField<scalar>(ptf, iF)
{
    if (false)
    {
        Info<<"construct hydroStatic sha1: bce59d96598c35361f2704fc0646503ea3f45bfa "
            "as copy/DimensionedField\n";
    }
}


// * * * * * * * * * * * * * * * * Destructor  * * * * * * * * * * * * * * * //

hydroStaticMixedValueFvPatchScalarField::
~hydroStaticMixedValueFvPatchScalarField()
{
    if (false)
    {
        Info<<"destroy hydroStatic sha1: bce59d96598c35361f2704fc0646503ea3f45bfa\n";
    }
}


// * * * * * * * * * * * * * * * Member Functions  * * * * * * * * * * * * * //

void hydroStaticMixedValueFvPatchScalarField::updateCoeffs()
{
    if (this->updated())
    {
        return;
    }

    if (false)
    {
        Info<<"updateCoeffs hydroStatic sha1: bce59d96598c35361f2704fc0646503ea3f45bfa\n";
    }

//{{{ begin code
    #line 47 "/home/hilary/OpenFOAM/hilary-10/run/RayleighBenard/NSeqns/Agrid/exnerFoamRef/explicit_dt002_FCT/0/Exnerp/boundaryField/ground"
const dictionary& environmentalProperties
                = db().lookupObject<IOdictionary>("environmentalProperties");

            const dictionary& thermoProperties
                = db().lookupObject<IOdictionary>("physicalProperties");
            
            dimensionedVector g(environmentalProperties.lookup("g"));

            const constTransport<hConstThermo<perfectGas<specie> > > air
            (
                 thermoProperties.subDict("mixture")
            );

            const dimensionedScalar Cp("Cp", dimGasConstant, air.Cp(0,0));

            const fvsPatchField<scalar>& thetapf
                 = patch().lookupPatchField<surfaceScalarField, scalar>("thetapf");
            const fvPatchField<scalar>& thetaa
                 = patch().lookupPatchField<volScalarField, scalar>("thetaa");
            const fvsPatchField<scalar>& thetaf
                 = patch().lookupPatchField<surfaceScalarField, scalar>("thetaf");

            this->refGrad() = -(g.value() & patch().nf())*thetapf
                                /(Cp.value()*thetaa*thetaf);
//}}} end code

    this->mixedFvPatchField<scalar>::updateCoeffs();
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace Foam

// ************************************************************************* //

