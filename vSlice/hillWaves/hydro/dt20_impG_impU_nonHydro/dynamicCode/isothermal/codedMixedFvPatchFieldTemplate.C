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
#line 35 "/home/hilary/OpenFOAM/hilary-10/run/vSlice/hillWaves/hydro/dt20_impG_impU_nonHydro/0/theta/boundaryField/ground"
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
    // SHA1 = 28c49afe766899046f3c4117cd54bb88cb7fabf0
    //
    // unique function name that can be checked if the correct library version
    // has been loaded
    void isothermal_28c49afe766899046f3c4117cd54bb88cb7fabf0(bool load)
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
    isothermalMixedValueFvPatchScalarField
);


const char* const isothermalMixedValueFvPatchScalarField::SHA1sum =
    "28c49afe766899046f3c4117cd54bb88cb7fabf0";


// * * * * * * * * * * * * * * * * Constructors  * * * * * * * * * * * * * * //

isothermalMixedValueFvPatchScalarField::
isothermalMixedValueFvPatchScalarField
(
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF
)
:
    mixedFvPatchField<scalar>(p, iF)
{
    if (false)
    {
        Info<<"construct isothermal sha1: 28c49afe766899046f3c4117cd54bb88cb7fabf0"
            " from patch/DimensionedField\n";
    }
}


isothermalMixedValueFvPatchScalarField::
isothermalMixedValueFvPatchScalarField
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
        Info<<"construct isothermal sha1: 28c49afe766899046f3c4117cd54bb88cb7fabf0"
            " from patch/dictionary\n";
    }
}


isothermalMixedValueFvPatchScalarField::
isothermalMixedValueFvPatchScalarField
(
    const isothermalMixedValueFvPatchScalarField& ptf,
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF,
    const fvPatchFieldMapper& mapper
)
:
    mixedFvPatchField<scalar>(ptf, p, iF, mapper)
{
    if (false)
    {
        Info<<"construct isothermal sha1: 28c49afe766899046f3c4117cd54bb88cb7fabf0"
            " from patch/DimensionedField/mapper\n";
    }
}


isothermalMixedValueFvPatchScalarField::
isothermalMixedValueFvPatchScalarField
(
    const isothermalMixedValueFvPatchScalarField& ptf,
    const DimensionedField<scalar, volMesh>& iF
)
:
    mixedFvPatchField<scalar>(ptf, iF)
{
    if (false)
    {
        Info<<"construct isothermal sha1: 28c49afe766899046f3c4117cd54bb88cb7fabf0 "
            "as copy/DimensionedField\n";
    }
}


// * * * * * * * * * * * * * * * * Destructor  * * * * * * * * * * * * * * * //

isothermalMixedValueFvPatchScalarField::
~isothermalMixedValueFvPatchScalarField()
{
    if (false)
    {
        Info<<"destroy isothermal sha1: 28c49afe766899046f3c4117cd54bb88cb7fabf0\n";
    }
}


// * * * * * * * * * * * * * * * Member Functions  * * * * * * * * * * * * * //

void isothermalMixedValueFvPatchScalarField::updateCoeffs()
{
    if (this->updated())
    {
        return;
    }

    if (false)
    {
        Info<<"updateCoeffs isothermal sha1: 28c49afe766899046f3c4117cd54bb88cb7fabf0\n";
    }

//{{{ begin code
    #line 49 "/home/hilary/OpenFOAM/hilary-10/run/vSlice/hillWaves/hydro/dt20_impG_impU_nonHydro/0/theta/boundaryField/ground"
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

            const fvPatchField<scalar>& Exner
                 = patch().lookupPatchField<volScalarField, scalar>("Exner");

            this->refGrad() = -(g.value() & patch().nf())/Cp.value()
                                /Exner.patchInternalField();
            //this->refGrad() = 2*(g.value() & patch().nf())/Cp.value()
            //                    /Exner.patchInternalField();
//}}} end code

    this->mixedFvPatchField<scalar>::updateCoeffs();
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace Foam

// ************************************************************************* //

