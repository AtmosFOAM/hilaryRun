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
    // SHA1 = c1643854df30187da2196cbeef3f76413b2e6272
    //
    // unique function name that can be checked if the correct library version
    // has been loaded
    void hydrostatic_c1643854df30187da2196cbeef3f76413b2e6272(bool load)
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
    hydrostaticMixedValueFvPatchScalarField
);


const char* const hydrostaticMixedValueFvPatchScalarField::SHA1sum =
    "c1643854df30187da2196cbeef3f76413b2e6272";


// * * * * * * * * * * * * * * * * Constructors  * * * * * * * * * * * * * * //

hydrostaticMixedValueFvPatchScalarField::
hydrostaticMixedValueFvPatchScalarField
(
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF
)
:
    mixedFvPatchField<scalar>(p, iF)
{
    if (false)
    {
        Info<<"construct hydrostatic sha1: c1643854df30187da2196cbeef3f76413b2e6272"
            " from patch/DimensionedField\n";
    }
}


hydrostaticMixedValueFvPatchScalarField::
hydrostaticMixedValueFvPatchScalarField
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
        Info<<"construct hydrostatic sha1: c1643854df30187da2196cbeef3f76413b2e6272"
            " from patch/dictionary\n";
    }
}


hydrostaticMixedValueFvPatchScalarField::
hydrostaticMixedValueFvPatchScalarField
(
    const hydrostaticMixedValueFvPatchScalarField& ptf,
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF,
    const fvPatchFieldMapper& mapper
)
:
    mixedFvPatchField<scalar>(ptf, p, iF, mapper)
{
    if (false)
    {
        Info<<"construct hydrostatic sha1: c1643854df30187da2196cbeef3f76413b2e6272"
            " from patch/DimensionedField/mapper\n";
    }
}


hydrostaticMixedValueFvPatchScalarField::
hydrostaticMixedValueFvPatchScalarField
(
    const hydrostaticMixedValueFvPatchScalarField& ptf,
    const DimensionedField<scalar, volMesh>& iF
)
:
    mixedFvPatchField<scalar>(ptf, iF)
{
    if (false)
    {
        Info<<"construct hydrostatic sha1: c1643854df30187da2196cbeef3f76413b2e6272 "
            "as copy/DimensionedField\n";
    }
}


// * * * * * * * * * * * * * * * * Destructor  * * * * * * * * * * * * * * * //

hydrostaticMixedValueFvPatchScalarField::
~hydrostaticMixedValueFvPatchScalarField()
{
    if (false)
    {
        Info<<"destroy hydrostatic sha1: c1643854df30187da2196cbeef3f76413b2e6272\n";
    }
}


// * * * * * * * * * * * * * * * Member Functions  * * * * * * * * * * * * * //

void hydrostaticMixedValueFvPatchScalarField::updateCoeffs()
{
    if (this->updated())
    {
        return;
    }

    if (false)
    {
        Info<<"updateCoeffs hydrostatic sha1: c1643854df30187da2196cbeef3f76413b2e6272\n";
    }

//{{{ begin code
    #line 35 "/home/hilary/OpenFOAM/hilary-10/run/vSlice/testGradP/0/P/boundaryField/ground"
this->refValue() = 1;
        this->refGrad() = vector(0,0,-0.1) & this->patch().nf();
        this->valueFraction() = 0;
//}}} end code

    this->mixedFvPatchField<scalar>::updateCoeffs();
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace Foam

// ************************************************************************* //

