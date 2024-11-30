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
    // SHA1 = d9f427d5a10f9e1a909f9163858c36a2fd1c3176
    //
    // unique function name that can be checked if the correct library version
    // has been loaded
    void hydrostaticP_d9f427d5a10f9e1a909f9163858c36a2fd1c3176(bool load)
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
    hydrostaticPMixedValueFvPatchScalarField
);


const char* const hydrostaticPMixedValueFvPatchScalarField::SHA1sum =
    "d9f427d5a10f9e1a909f9163858c36a2fd1c3176";


// * * * * * * * * * * * * * * * * Constructors  * * * * * * * * * * * * * * //

hydrostaticPMixedValueFvPatchScalarField::
hydrostaticPMixedValueFvPatchScalarField
(
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF
)
:
    mixedFvPatchField<scalar>(p, iF)
{
    if (false)
    {
        Info<<"construct hydrostaticP sha1: d9f427d5a10f9e1a909f9163858c36a2fd1c3176"
            " from patch/DimensionedField\n";
    }
}


hydrostaticPMixedValueFvPatchScalarField::
hydrostaticPMixedValueFvPatchScalarField
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
        Info<<"construct hydrostaticP sha1: d9f427d5a10f9e1a909f9163858c36a2fd1c3176"
            " from patch/dictionary\n";
    }
}


hydrostaticPMixedValueFvPatchScalarField::
hydrostaticPMixedValueFvPatchScalarField
(
    const hydrostaticPMixedValueFvPatchScalarField& ptf,
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF,
    const fvPatchFieldMapper& mapper
)
:
    mixedFvPatchField<scalar>(ptf, p, iF, mapper)
{
    if (false)
    {
        Info<<"construct hydrostaticP sha1: d9f427d5a10f9e1a909f9163858c36a2fd1c3176"
            " from patch/DimensionedField/mapper\n";
    }
}


hydrostaticPMixedValueFvPatchScalarField::
hydrostaticPMixedValueFvPatchScalarField
(
    const hydrostaticPMixedValueFvPatchScalarField& ptf,
    const DimensionedField<scalar, volMesh>& iF
)
:
    mixedFvPatchField<scalar>(ptf, iF)
{
    if (false)
    {
        Info<<"construct hydrostaticP sha1: d9f427d5a10f9e1a909f9163858c36a2fd1c3176 "
            "as copy/DimensionedField\n";
    }
}


// * * * * * * * * * * * * * * * * Destructor  * * * * * * * * * * * * * * * //

hydrostaticPMixedValueFvPatchScalarField::
~hydrostaticPMixedValueFvPatchScalarField()
{
    if (false)
    {
        Info<<"destroy hydrostaticP sha1: d9f427d5a10f9e1a909f9163858c36a2fd1c3176\n";
    }
}


// * * * * * * * * * * * * * * * Member Functions  * * * * * * * * * * * * * //

void hydrostaticPMixedValueFvPatchScalarField::updateCoeffs()
{
    if (this->updated())
    {
        return;
    }

    if (false)
    {
        Info<<"updateCoeffs hydrostaticP sha1: d9f427d5a10f9e1a909f9163858c36a2fd1c3176\n";
    }

//{{{ begin code
    #line 33 "/home/hilary/OpenFOAM/hilary-10/run/vSlice/testGradP/0/P/boundaryField/ground"
vector g(0,0,-0.1);
            this->refGrad() = 0.1; //g & this->patch().nf();
//}}} end code

    this->mixedFvPatchField<scalar>::updateCoeffs();
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace Foam

// ************************************************************************* //

