﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Requests
{
    public class ReviewUpdateRequest
    {
        [Range(1, 5, ErrorMessage = "The value must be between 1 and 5.")]
        public int? Value { get; set; }

        public string? Description { get; set; }
    }
}
