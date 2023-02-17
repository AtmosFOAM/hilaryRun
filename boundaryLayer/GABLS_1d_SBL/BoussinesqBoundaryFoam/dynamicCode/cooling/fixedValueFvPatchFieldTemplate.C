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

#include "fixedValueFvPatchFieldTemplate.H"
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
    // SHA1 = 09a4e986910576ce4933b627e8ba1ded9bf34760
    //
    // unique function name that can be checked if the correct library version
    // has been loaded
    void cooling_09a4e986910576ce4933b627e8ba1ded9bf34760(bool load)
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
    coolingFixedValueFvPatchScalarField
);


const char* const coolingFixedValueFvPatchScalarField::SHA1sum =
    "09a4e986910576ce4933b627e8ba1ded9bf34760";


// * * * * * * * * * * * * * * * * Constructors  * * * * * * * * * * * * * * //

coolingFixedValueFvPatchScalarField::
coolingFixedValueFvPatchScalarField
(
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF
)
:
    fixedValueFvPatchField<scalar>(p, iF)
{
    if (false)
    {
        Info<<"construct cooling sha1: 09a4e986910576ce4933b627e8ba1ded9bf34760"
            " from patch/DimensionedField\n";
    }
}


coolingFixedValueFvPatchScalarField::
coolingFixedValueFvPatchScalarField
(
    const coolingFixedValueFvPatchScalarField& ptf,
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF,
    const fvPatchFieldMapper& mapper
)
:
    fixedValueFvPatchField<scalar>(ptf, p, iF, mapper)
{
    if (false)
    {
        Info<<"construct cooling sha1: 09a4e986910576ce4933b627e8ba1ded9bf34760"
            " from patch/DimensionedField/mapper\n";
    }
}


coolingFixedValueFvPatchScalarField::
coolingFixedValueFvPatchScalarField
(
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF,
    const dictionary& dict
)
:
    fixedValueFvPatchField<scalar>(p, iF, dict)
{
    if (false)
    {
        Info<<"construct cooling sha1: 09a4e986910576ce4933b627e8ba1ded9bf34760"
            " from patch/dictionary\n";
    }
}


coolingFixedValueFvPatchScalarField::
coolingFixedValueFvPatchScalarField
(
    const coolingFixedValueFvPatchScalarField& ptf
)
:
    fixedValueFvPatchField<scalar>(ptf)
{
    if (false)
    {
        Info<<"construct cooling sha1: 09a4e986910576ce4933b627e8ba1ded9bf34760"
            " as copy\n";
    }
}


coolingFixedValueFvPatchScalarField::
coolingFixedValueFvPatchScalarField
(
    const coolingFixedValueFvPatchScalarField& ptf,
    const DimensionedField<scalar, volMesh>& iF
)
:
    fixedValueFvPatchField<scalar>(ptf, iF)
{
    if (false)
    {
        Info<<"construct cooling sha1: 09a4e986910576ce4933b627e8ba1ded9bf34760 "
            "as copy/DimensionedField\n";
    }
}


// * * * * * * * * * * * * * * * * Destructor  * * * * * * * * * * * * * * * //

coolingFixedValueFvPatchScalarField::
~coolingFixedValueFvPatchScalarField()
{
    if (false)
    {
        Info<<"destroy cooling sha1: 09a4e986910576ce4933b627e8ba1ded9bf34760\n";
    }
}


// * * * * * * * * * * * * * * * Member Functions  * * * * * * * * * * * * * //

void coolingFixedValueFvPatchScalarField::updateCoeffs()
{
    if (this->updated())
    {
        return;
    }

    if (false)
    {
        Info<<"updateCoeffs cooling sha1: 09a4e986910576ce4933b627e8ba1ded9bf34760\n";
    }

//{{{ begin code
    #line 65 "/home/hilary/OpenFOAM/hilary-7/run/hilary/GABLS_1d_SBL/BoussinesqBoundaryFoam/0/b.boundaryField.ground"
const scalar t = this->db().time().value();
            const scalar b = ${:b0} + ${:heatingRate}*t;
            operator==(b);
//}}} end code

    this->fixedValueFvPatchField<scalar>::updateCoeffs();
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace Foam

// ************************************************************************* //

