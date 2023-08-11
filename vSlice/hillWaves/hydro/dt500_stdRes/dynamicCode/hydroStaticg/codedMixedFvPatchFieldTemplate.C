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
#line 33 "./dt500_stdRes/0/Exnerg/boundaryField/ground"
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
    // SHA1 = 5c66fe45cd8227ec3d0a5406595b9a425c5e2969
    //
    // unique function name that can be checked if the correct library version
    // has been loaded
    void hydroStaticg_5c66fe45cd8227ec3d0a5406595b9a425c5e2969(bool load)
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
    hydroStaticgMixedValueFvPatchScalarField
);


const char* const hydroStaticgMixedValueFvPatchScalarField::SHA1sum =
    "5c66fe45cd8227ec3d0a5406595b9a425c5e2969";


// * * * * * * * * * * * * * * * * Constructors  * * * * * * * * * * * * * * //

hydroStaticgMixedValueFvPatchScalarField::
hydroStaticgMixedValueFvPatchScalarField
(
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF
)
:
    mixedFvPatchField<scalar>(p, iF)
{
    if (false)
    {
        Info<<"construct hydroStaticg sha1: 5c66fe45cd8227ec3d0a5406595b9a425c5e2969"
            " from patch/DimensionedField\n";
    }
}


hydroStaticgMixedValueFvPatchScalarField::
hydroStaticgMixedValueFvPatchScalarField
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
        Info<<"construct hydroStaticg sha1: 5c66fe45cd8227ec3d0a5406595b9a425c5e2969"
            " from patch/dictionary\n";
    }
}


hydroStaticgMixedValueFvPatchScalarField::
hydroStaticgMixedValueFvPatchScalarField
(
    const hydroStaticgMixedValueFvPatchScalarField& ptf,
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF,
    const fvPatchFieldMapper& mapper
)
:
    mixedFvPatchField<scalar>(ptf, p, iF, mapper)
{
    if (false)
    {
        Info<<"construct hydroStaticg sha1: 5c66fe45cd8227ec3d0a5406595b9a425c5e2969"
            " from patch/DimensionedField/mapper\n";
    }
}


hydroStaticgMixedValueFvPatchScalarField::
hydroStaticgMixedValueFvPatchScalarField
(
    const hydroStaticgMixedValueFvPatchScalarField& ptf,
    const DimensionedField<scalar, volMesh>& iF
)
:
    mixedFvPatchField<scalar>(ptf, iF)
{
    if (false)
    {
        Info<<"construct hydroStaticg sha1: 5c66fe45cd8227ec3d0a5406595b9a425c5e2969 "
            "as copy/DimensionedField\n";
    }
}


// * * * * * * * * * * * * * * * * Destructor  * * * * * * * * * * * * * * * //

hydroStaticgMixedValueFvPatchScalarField::
~hydroStaticgMixedValueFvPatchScalarField()
{
    if (false)
    {
        Info<<"destroy hydroStaticg sha1: 5c66fe45cd8227ec3d0a5406595b9a425c5e2969\n";
    }
}


// * * * * * * * * * * * * * * * Member Functions  * * * * * * * * * * * * * //

void hydroStaticgMixedValueFvPatchScalarField::updateCoeffs()
{
    if (this->updated())
    {
        return;
    }

    if (false)
    {
        Info<<"updateCoeffs hydroStaticg sha1: 5c66fe45cd8227ec3d0a5406595b9a425c5e2969\n";
    }

//{{{ begin code
    #line 47 "./dt500_stdRes/0/Exnerg/boundaryField/ground"
const dictionary& thermoProperties
                = db().lookupObject<IOdictionary>("physicalProperties");

            const constTransport<hConstThermo<perfectGas<specie> > > air
            (
                 thermoProperties.subDict("mixture")
            );

            const dimensionedScalar Cp("Cp", dimGasConstant, air.Cp(0,0));

            const fvPatchField<scalar>& theta
                 = patch().lookupPatchField<volScalarField, scalar>("theta");
                 
            const fvsPatchField<scalar>& gradTheta
                 = patch().lookupPatchField<surfaceScalarField, scalar>("gradTheta");
                 
            const fvPatchField<scalar>& gh
                 = patch().lookupPatchField<volScalarField, scalar>("gh");

            this->refGrad() = gh*gradTheta/(Cp.value()*sqr(theta));
//}}} end code

    this->mixedFvPatchField<scalar>::updateCoeffs();
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace Foam

// ************************************************************************* //

